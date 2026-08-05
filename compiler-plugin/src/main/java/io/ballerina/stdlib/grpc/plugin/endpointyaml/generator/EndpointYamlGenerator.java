/*
 * Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.grpc.plugin.endpointyaml.generator;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.fasterxml.jackson.dataformat.yaml.YAMLGenerator;
import io.ballerina.compiler.api.SemanticModel;
import io.ballerina.compiler.api.symbols.ModuleSymbol;
import io.ballerina.compiler.api.symbols.Symbol;
import io.ballerina.compiler.syntax.tree.BasicLiteralNode;
import io.ballerina.compiler.syntax.tree.CheckExpressionNode;
import io.ballerina.compiler.syntax.tree.ExplicitNewExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.FunctionArgumentNode;
import io.ballerina.compiler.syntax.tree.ImplicitNewExpressionNode;
import io.ballerina.compiler.syntax.tree.ListenerDeclarationNode;
import io.ballerina.compiler.syntax.tree.NamedArgumentNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeParser;
import io.ballerina.compiler.syntax.tree.ParenthesizedArgList;
import io.ballerina.compiler.syntax.tree.PositionalArgumentNode;
import io.ballerina.compiler.syntax.tree.QualifiedNameReferenceNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.runtime.api.utils.IdentifierUtils;
import io.ballerina.tools.diagnostics.DiagnosticFactory;
import io.ballerina.tools.diagnostics.DiagnosticInfo;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;

import java.io.IOException;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Generates the endpoint entry for a single gRPC service declaration to be included in {@code endpoints.yaml}.
 */
public class EndpointYamlGenerator {
    private final ServiceDeclarationNode node;
    private final SyntaxNodeAnalysisContext context;
    private final String schemaFileName;

    private boolean hasReportedError;

    final PackageMemberVisitor packageMemberVisitor = new PackageMemberVisitor();

    private static final String ARTIFACT = "artifact";
    private static final String GRPC = "GRPC";
    private static final String ENDPOINTS_FILE_NAME = "endpoints.yaml";

    private record ListenerInfo(Optional<ParenthesizedArgList> argList) {
    }

    private record ListenerResolution(Optional<ParenthesizedArgList> argList) {
    }

    private record PositionalPortResolution(int nextIndex, Optional<Integer> port) {
    }

    public EndpointYamlGenerator(SyntaxNodeAnalysisContext context) {
        this.node = (ServiceDeclarationNode) context.node();
        this.context = context;

        FileNameGeneratorUtil fileNameGeneratorUtil = new FileNameGeneratorUtil(context);
        this.schemaFileName = fileNameGeneratorUtil.getFileName();
    }

    public List<Endpoint> getEndpoints() {
        String moduleName = context.moduleId().moduleName();
        ensureModuleVisited(moduleName);

        List<ListenerInfo> listenerInfos = resolveListenerInfo(moduleName);
        String basePath = buildBasePath();

        List<Endpoint> endpoints = new ArrayList<>();
        for (ListenerInfo listenerInfo : listenerInfos) {
            Optional<Integer> port = resolvePort(listenerInfo.argList());
            if (port.isEmpty()) {
                continue;
            }
            endpoints.add(new Endpoint(basePath, port.get(), basePath, GRPC, this.schemaFileName));
        }
        return endpoints;
    }

    /**
     * Indicates whether the last {@link #getEndpoints()} call reported a compilation error
     * (e.g. an unresolvable required port). Callers should skip exporting artifacts for this
     * service when this returns {@code true}, rather than exporting from a partial result.
     */
    public boolean hasReportedError() {
        return hasReportedError;
    }

    private void ensureModuleVisited(String moduleName) {
        Map<String, ModuleMemberVisitor> moduleVisitors = packageMemberVisitor.createModuleVisitor(moduleName,
                context.semanticModel());
        ModuleMemberVisitor moduleMemberVisitor = moduleVisitors.get(moduleName);
        packageMemberVisitor.setModuleVisitors(moduleVisitors);

        context.currentPackage()
                .module(context.moduleId())
                .documentIds()
                .forEach(docId -> {
                    SyntaxTree tree = context.currentPackage()
                            .module(context.moduleId())
                            .document(docId)
                            .syntaxTree();
                    tree.rootNode().accept(moduleMemberVisitor);
                });

    }

    private List<ListenerInfo> resolveListenerInfo(String moduleName) {
        List<ListenerInfo> listenerInfos = new ArrayList<>();
        SemanticModel semanticModel = context.semanticModel();

        for (ExpressionNode raw : node.expressions()) {
            ExpressionNode expr = unwrapCheckExpression(raw);
            Optional<ParenthesizedArgList> argList;

            if (expr.kind().equals(SyntaxKind.EXPLICIT_NEW_EXPRESSION)) {
                ExplicitNewExpressionNode explicit = (ExplicitNewExpressionNode) expr;
                argList = Optional.ofNullable(explicit.parenthesizedArgList());
            } else if (expr.kind().equals(SyntaxKind.IMPLICIT_NEW_EXPRESSION)) {
                ImplicitNewExpressionNode implicit = (ImplicitNewExpressionNode) expr;
                argList = implicit.parenthesizedArgList();
            } else if (isNameReference(expr)) {
                ListenerResolution resolution = resolveNamedListener(expr, moduleName, semanticModel);
                argList = resolution.argList();
            } else {
                continue;
            }
            listenerInfos.add(new ListenerInfo(argList));
        }

        return listenerInfos;
    }

    private ExpressionNode unwrapCheckExpression(ExpressionNode expr) {
        if (expr.kind().equals(SyntaxKind.CHECK_EXPRESSION)) {
            return ((CheckExpressionNode) expr).expression();
        }
        return expr;
    }

    private boolean isNameReference(ExpressionNode expr) {
        return expr.kind().equals(SyntaxKind.SIMPLE_NAME_REFERENCE) ||
                expr.kind().equals(SyntaxKind.QUALIFIED_NAME_REFERENCE);
    }

    private ListenerResolution resolveNamedListener(ExpressionNode expr, String moduleName,
                                                    SemanticModel semanticModel) {
        String listenerModuleName = getModuleName(semanticModel, expr);
        if (listenerModuleName.isEmpty()) {
            listenerModuleName = moduleName;
        }

        String listenerName;

        if (expr instanceof QualifiedNameReferenceNode refNode) {
            listenerName = unescapeIdentifier(refNode.identifier().text().trim());
        } else {
            listenerName = unescapeIdentifier(expr.toString().trim());
        }

        Optional<ListenerDeclarationNode> declOpt =
                packageMemberVisitor.getListenerDeclaration(listenerModuleName, listenerName);

        if (declOpt.isEmpty()) {
            return new ListenerResolution(Optional.empty());
        }

        ListenerDeclarationNode decl = declOpt.get();
        Optional<ParenthesizedArgList> argList = extractArgListFromListenerDecl(decl);
        return new ListenerResolution(argList);
    }

    private Optional<ParenthesizedArgList> extractArgListFromListenerDecl(ListenerDeclarationNode decl) {
        Node initNode = decl.initializer();
        if (initNode == null) {
            return Optional.empty();
        }
        ExpressionNode initializer = (ExpressionNode) initNode;
        initializer = unwrapCheckExpression(initializer);

        return switch (initializer.kind()) {
            case EXPLICIT_NEW_EXPRESSION ->
                    Optional.ofNullable(((ExplicitNewExpressionNode) initializer).parenthesizedArgList());
            case IMPLICIT_NEW_EXPRESSION -> ((ImplicitNewExpressionNode) initializer).parenthesizedArgList();
            default -> Optional.empty();
        };
    }

    private Optional<Integer> resolvePort(Optional<ParenthesizedArgList> argListOpt) {
        if (argListOpt.isEmpty()) {
            return Optional.empty();
        }
        SeparatedNodeList<FunctionArgumentNode> arguments = argListOpt.get().arguments();
        PositionalPortResolution positional = resolvePortFromPositionalArgs(arguments);
        Optional<Integer> namedPort = resolvePortFromNamedArgs(arguments, positional.nextIndex());
        return namedPort.isPresent() ? namedPort : positional.port();
    }

    private PositionalPortResolution resolvePortFromPositionalArgs(SeparatedNodeList<FunctionArgumentNode> arguments) {
        int index = 0;
        Optional<Integer> resolvedPort = Optional.empty();
        for (; index < arguments.size(); index++) {
            FunctionArgumentNode arg = arguments.get(index);
            if (arg instanceof NamedArgumentNode) {
                break;
            }
            if (index == 0) {
                PositionalArgumentNode portArg = (PositionalArgumentNode) arg;
                resolvedPort = parsePortValue(
                        getPortValue(portArg.expression(), context.semanticModel(), context));
            }
        }
        return new PositionalPortResolution(index, resolvedPort);
    }

    private Optional<Integer> resolvePortFromNamedArgs(SeparatedNodeList<FunctionArgumentNode> arguments,
                                                       int startIndex) {
        for (int i = startIndex; i < arguments.size(); i++) {
            FunctionArgumentNode arg = arguments.get(i);
            if (arg instanceof NamedArgumentNode namedArg &&
                    namedArg.argumentName().toString().trim().equals("port")) {
                return parsePortValue(getPortValue(namedArg.expression(), context.semanticModel(), context));
            }
        }
        return Optional.empty();
    }

    private Optional<Integer> parsePortValue(Optional<String> portValue) {
        if (portValue.isEmpty()) {
            return Optional.empty();
        }
        try {
            return Optional.of(Integer.parseInt(portValue.get()));
        } catch (NumberFormatException e) {
            reportInvalidPortConfigDiagnostic(context);
            return Optional.empty();
        }
    }

    private String buildBasePath() {
        StringBuilder basePath = new StringBuilder();
        for (Node identifierNode : node.absoluteResourcePath()) {
            basePath.append(identifierNode.toString().replace("\"", "").trim());
        }
        return basePath.toString();
    }

    public static void writeEndpointsYaml(Path outPath, List<Endpoint> endpoints) throws IOException {
        Files.createDirectories(outPath.resolve(ARTIFACT));
        Path path = outPath.resolve(ARTIFACT).resolve(ENDPOINTS_FILE_NAME).toAbsolutePath();
        writeYaml(path, new EndpointsWrapper(endpoints));
    }

    private static void writeYaml(Path path, EndpointsWrapper wrapper) throws IOException {
        YAMLFactory yamlFactory = YAMLFactory.builder()
                .disable(YAMLGenerator.Feature.WRITE_DOC_START_MARKER)
                .build();
        ObjectMapper mapper = new ObjectMapper(yamlFactory);
        mapper.findAndRegisterModules();

        try (Writer writer = Files.newBufferedWriter(path)) {
            mapper.writeValue(writer, wrapper);
        } catch (IOException e) {
            throw new IOException("Failed to write endpoints yaml to " + path, e);
        }
    }

    private Optional<String> getPortValue(ExpressionNode expression, SemanticModel semanticModel,
                                          SyntaxNodeAnalysisContext context) {
        return getPortValue(expression, false, semanticModel, context);
    }

    private Optional<String> getPortValue(ExpressionNode expression, boolean isConfigurablePort,
                                          SemanticModel semanticModel, SyntaxNodeAnalysisContext context) {
        if (expression.kind().equals(SyntaxKind.NUMERIC_LITERAL)) {
            return resolveNumericLiteral(expression);
        }
        if (!isNameReference(expression)) {
            return Optional.empty();
        }
        return resolvePortFromVariable(expression, semanticModel, context, isConfigurablePort);
    }

    private Optional<String> resolveNumericLiteral(ExpressionNode expression) {
        BasicLiteralNode literal = (BasicLiteralNode) expression;
        return Optional.of(literal.literalToken().text());
    }

    private Optional<String> resolvePortFromVariable(ExpressionNode expression,
                                                     SemanticModel semanticModel,
                                                     SyntaxNodeAnalysisContext context, boolean isConfigurablePort) {
        String moduleName = getModuleName(semanticModel, expression);
        String portVariableName = extractVariableName(expression);

        Optional<ModuleMemberVisitor.VariableDeclaredValue> varOpt =
                packageMemberVisitor.getVariableDeclaredValue(moduleName, portVariableName);

        if (varOpt.isEmpty()) {
            return Optional.empty();
        }

        ModuleMemberVisitor.VariableDeclaredValue varVal = varOpt.get();
        String portValueSource = String.valueOf(varVal.value());
        ExpressionNode portExpr = portValueSource.isEmpty() ? null : NodeParser.parseExpression(portValueSource);

        if (portExpr == null || portExpr.isMissing()) {
            return Optional.empty();
        }

        return resolvePortExpression(portExpr, varVal.isConfigurable(), isConfigurablePort, semanticModel, context);
    }

    private String extractVariableName(ExpressionNode expression) {
        if (expression instanceof QualifiedNameReferenceNode refNode) {
            return unescapeIdentifier(refNode.identifier().text().trim());
        }
        return unescapeIdentifier(expression.toString().trim());
    }

    private Optional<String> resolvePortExpression(ExpressionNode portExpr, boolean isConfigurable,
                                                   boolean isConfigurablePort,
                                                   SemanticModel semanticModel,
                                                   SyntaxNodeAnalysisContext context) {
        if (portExpr.kind().equals(SyntaxKind.REQUIRED_EXPRESSION)) {
            reportMissingPortConfigDiagnostic(context);
            return Optional.empty();
        }
        if (isConfigurable || isConfigurablePort) {
            reportDefualtPortConfigDiagnostic(context);
        }
        if (portExpr.kind().equals(SyntaxKind.NUMERIC_LITERAL)) {
            return resolveNumericLiteral(portExpr);
        }
        return getPortValue(portExpr, isConfigurable, semanticModel, context);
    }

    private void reportMissingPortConfigDiagnostic(SyntaxNodeAnalysisContext context) {
        hasReportedError = true;
        DiagnosticInfo diagnosticInfo = new DiagnosticInfo(
                "PORT_CONFIGURATION_BEING_NULL",
                "The configurable value provided for the port should have a " +
                        "default value to generate the server details" +
                "when --export-endpoints flag presents",
                DiagnosticSeverity.ERROR
        );
        context.reportDiagnostic(DiagnosticFactory.createDiagnostic(diagnosticInfo, context.node().location()));
    }

    private void reportInvalidPortConfigDiagnostic(SyntaxNodeAnalysisContext context) {
        hasReportedError = true;
        DiagnosticInfo diagnosticInfo = new DiagnosticInfo(
                "INVALID_PORT_CONFIGURATION",
                "The configured port value is not a valid integer; unable to generate the server details " +
                        "when --export-endpoints flag presents",
                DiagnosticSeverity.ERROR
        );
        context.reportDiagnostic(DiagnosticFactory.createDiagnostic(diagnosticInfo, context.node().location()));
    }

    private void reportDefualtPortConfigDiagnostic(SyntaxNodeAnalysisContext context) {
        DiagnosticInfo diagnosticInfo = new DiagnosticInfo(
                "PORT_CONFIGURATION_BEING_NULL",
                "The server port is defined as a configurable. Hence," +
                        "using the default value to generate the server information" +
                "when --export-endpoints flag presents",
                DiagnosticSeverity.WARNING
        );
        context.reportDiagnostic(DiagnosticFactory.createDiagnostic(diagnosticInfo, context.node().location()));
    }

    public static String unescapeIdentifier(String parameterName) {
        String unescapedParamName = IdentifierUtils.unescapeBallerina(parameterName);
        return unescapedParamName.replace("\\\\", "").replace("'", "");
    }

    public static String getModuleName(SemanticModel semanticModel, Node node) {
        Optional<Symbol> symbol = semanticModel.symbol(node);
        if (symbol.isEmpty()) {
            return "";
        }
        return getModuleName(symbol.get());
    }

    public static String getModuleName(Symbol symbol) {
        Optional<ModuleSymbol> module = symbol.getModule();
        if (module.isEmpty()) {
            return "";
        }
        return module.get().id().moduleName();
    }

}
