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

import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.InvalidProtocolBufferException;
import io.ballerina.compiler.api.SemanticModel;
import io.ballerina.compiler.api.symbols.ConstantSymbol;
import io.ballerina.compiler.api.symbols.SymbolKind;
import io.ballerina.compiler.syntax.tree.AnnotationNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.MappingFieldNode;
import io.ballerina.compiler.syntax.tree.MetadataNode;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SpecificFieldNode;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.tools.diagnostics.DiagnosticFactory;
import io.ballerina.tools.diagnostics.DiagnosticInfo;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;

import java.util.Optional;
import java.util.Set;
import java.util.concurrent.atomic.AtomicReference;

public class ServiceDescExtractor {

    private static final Set<String> DESCRIPTOR_ANNOTATION_NAMES = Set.of(
            "grpc:Descriptor",
            "grpc:ServiceDescriptor"
    );

    private static final Set<String> DESCRIPTOR_FIELD_NAMES = Set.of(
            "value",
            "descriptor"
    );

    private final SemanticModel semanticModel;
    private final SyntaxNodeAnalysisContext context;

    private final AtomicReference<DescriptorProtos.FileDescriptorProto> fileDescriptor
            = new AtomicReference<>();

    public ServiceDescExtractor(SemanticModel semanticModel,
                                SyntaxNodeAnalysisContext context) {
        this.semanticModel = semanticModel;
        this.context = context;
    }

    public AtomicReference<DescriptorProtos.FileDescriptorProto> extract() {
        ((ServiceDeclarationNode) context.node()).metadata().ifPresent(this::processMetadata);
        return new AtomicReference<>(this.fileDescriptor.get());
    }

    private void processMetadata(MetadataNode metadata) {
        for (AnnotationNode annNode : metadata.annotations()) {
            String annotationName = annNode.annotReference().toString().trim();

            if (DESCRIPTOR_ANNOTATION_NAMES.stream().noneMatch(annotationName::equals)) {
                continue;
            }

            annNode.annotValue().ifPresent(mappingExpr -> {
                for (MappingFieldNode field : mappingExpr.fields()) {
                    if (field instanceof SpecificFieldNode specificField) {
                        processSpecificField(specificField);
                    }
                }
            });
        }
    }

    private void processSpecificField(SpecificFieldNode specificField) {
        String fieldName = specificField.fieldName().toString().trim()
                .replaceAll("'", "");

        if (!DESCRIPTOR_FIELD_NAMES.contains(fieldName)) {
            return;
        }

        specificField.valueExpr().ifPresent(expr -> {

            Optional<String> hexValue = resolveAsConstant(expr);

            hexValue.ifPresentOrElse(
                    this::parseHexDescriptor,
                    () -> debug("Could not resolve hex value for field: " + fieldName)
            );
        });
    }

    private Optional<String> resolveAsConstant(ExpressionNode expr) {
        return semanticModel.symbol(expr)
            .filter(symbol -> symbol.kind() == SymbolKind.CONSTANT)
            .map(symbol -> (ConstantSymbol) symbol)
            .map(ConstantSymbol::constValue)
            .filter(val -> val != null)
            .map(val -> sanitizeHex(val.toString()));
    }

    private void parseHexDescriptor(String hex) {
        if (hex.isEmpty()) {
            debug("Hex string is empty");
            return;
        }

        if (hex.length() % 2 != 0) {
            debug("Hex string has odd length — likely corrupted: " + hex.length());
            return;
        }

        byte[] bytes = hexToBytes(hex);
        tryParseAsFileDescriptorProto(bytes);

        if (fileDescriptor.get() == null) {
            tryParseAsFileDescriptorSet(bytes);
        }
    }

    private void tryParseAsFileDescriptorProto(byte[] bytes) {
        try {
            DescriptorProtos.FileDescriptorProto fds =
                    DescriptorProtos.FileDescriptorProto.parseFrom(bytes);
            this.fileDescriptor.set(fds);
        } catch (InvalidProtocolBufferException e) {
            debug("Not a valid FileDescriptorProto: " + e.getMessage());
        }
    }

    private void tryParseAsFileDescriptorSet(byte[] bytes) {
        try {
            DescriptorProtos.FileDescriptorSet set =
                    DescriptorProtos.FileDescriptorSet.parseFrom(bytes);
            if (set.getFileCount() > 0) {
                DescriptorProtos.FileDescriptorProto fds =
                        set.getFile(set.getFileCount() - 1);
                this.fileDescriptor.set(fds);
            }
        } catch (InvalidProtocolBufferException e) {
            debug("Not a valid FileDescriptorSet: " + e.getMessage());
        }
    }

    private static String sanitizeHex(String raw) {
        return raw.trim()
            .replaceAll("\\s+", "")
            .replaceAll("^\"(.*)\"$", "$1")
            .replaceAll("^0[xX]", "");
    }

    private static byte[] hexToBytes(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                    + Character.digit(hex.charAt(i + 1), 16));
        }
        return data;
    }

    private void debug(String message) {
        context.reportDiagnostic(
            DiagnosticFactory.createDiagnostic(
                new DiagnosticInfo(
                    "GRPC_PLUGIN_DEBUG",
                    "[grpc-plugin] " + message,
                    DiagnosticSeverity.WARNING
                ),
                ((ServiceDeclarationNode) context.node()).location()
            )
        );
    }
}
