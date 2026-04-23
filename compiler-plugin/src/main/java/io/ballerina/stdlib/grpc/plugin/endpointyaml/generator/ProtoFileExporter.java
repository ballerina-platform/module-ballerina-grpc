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
import io.ballerina.compiler.api.SemanticModel;
import io.ballerina.projects.Package;
import io.ballerina.projects.Project;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.atomic.AtomicReference;

public class ProtoFileExporter {
    private static final String ARTIFACT = "artifact";
    private final SyntaxNodeAnalysisContext context;
    private final SemanticModel semanticModel;

    public ProtoFileExporter(SyntaxNodeAnalysisContext context) {
        this.context = context;
        this.semanticModel = this.context.semanticModel();
    }
    public void exportProtoFile() throws IOException {
        ServiceDescExtractor descExtractor = new ServiceDescExtractor(this.semanticModel, context);
        AtomicReference<DescriptorProtos.FileDescriptorProto> fds = descExtractor.extract();
        FileNameGeneratorUtil fileNameGeneratorUtil = new FileNameGeneratorUtil(this.context);
        String filePath = fileNameGeneratorUtil.getFileName();
        Package currentPackage = this.context.currentPackage();
        Project project = currentPackage.project();
        Path outPath = project.targetDir();
        Files.createDirectories(outPath.resolve(ARTIFACT));
        Path path = outPath.resolve(ARTIFACT).resolve(filePath).toAbsolutePath();
        ProtoFileWriter.writeToProtoFile(fds, path.toString());
    }
}
