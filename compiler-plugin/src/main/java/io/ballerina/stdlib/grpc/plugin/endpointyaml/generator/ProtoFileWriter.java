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

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicReference;

public class ProtoFileWriter {

    private ProtoFileWriter() {
    }

    public static void writeToProtoFile(
            AtomicReference<DescriptorProtos.FileDescriptorProto> fileDescriptor,
            String outputPath) throws IOException {

        DescriptorProtos.FileDescriptorProto proto = fileDescriptor.get();

        try (PrintWriter writer = new PrintWriter(outputPath, StandardCharsets.UTF_8)) {
            // Syntax
            writer.println("syntax = \"" + proto.getSyntax() + "\";");
            writer.println();

            // Package
            if (!proto.getPackage().isEmpty()) {
                writer.println("package " + proto.getPackage() + ";");
                writer.println();
            }

            // Imports
            for (String dep : proto.getDependencyList()) {
                writer.println("import \"" + dep + "\";");
            }
            if (!proto.getDependencyList().isEmpty()) {
                writer.println();
            }

            // Options
            if (proto.hasOptions()) {
                DescriptorProtos.FileOptions opts = proto.getOptions();
                if (opts.hasJavaPackage()) {
                    writer.println("option java_package = \"" + opts.getJavaPackage() + "\";");
                }
                if (opts.hasJavaOuterClassname()) {
                    writer.println("option java_outer_classname = \"" + opts.getJavaOuterClassname() + "\";");
                }
                if (opts.hasJavaMultipleFiles()) {
                    writer.println("option java_multiple_files = " + opts.getJavaMultipleFiles() + ";");
                }
                writer.println();
            }

            // Enums
            for (DescriptorProtos.EnumDescriptorProto enumType : proto.getEnumTypeList()) {
                writeEnum(writer, enumType, "");
            }

            // Messages
            for (DescriptorProtos.DescriptorProto message : proto.getMessageTypeList()) {
                writeMessage(writer, message, "");
            }

            // Services
            for (DescriptorProtos.ServiceDescriptorProto service : proto.getServiceList()) {
                writeService(writer, service);
            }
        }
    }

    private static void writeMessage(PrintWriter writer,
                                     DescriptorProtos.DescriptorProto message,
                                     String indent) {
        writer.println(indent + "message " + message.getName() + " {");
        String inner = indent + "  ";

        // Nested enums
        for (DescriptorProtos.EnumDescriptorProto enumType : message.getEnumTypeList()) {
            writeEnum(writer, enumType, inner);
        }

        // Nested messages
        for (DescriptorProtos.DescriptorProto nested : message.getNestedTypeList()) {
            writeMessage(writer, nested, inner);
        }

        // Fields
        for (DescriptorProtos.FieldDescriptorProto field : message.getFieldList()) {
            writeField(writer, field, inner);
        }

        // Oneofs
        for (DescriptorProtos.OneofDescriptorProto oneof : message.getOneofDeclList()) {
            writer.println(inner + "oneof " + oneof.getName() + " {");
            for (DescriptorProtos.FieldDescriptorProto field : message.getFieldList()) {
                if (field.hasOneofIndex()) {
                    writeField(writer, field, inner + "  ");
                }
            }
            writer.println(inner + "}");
        }

        writer.println(indent + "}");
        writer.println();
    }

    private static void writeField(PrintWriter writer,
                                   DescriptorProtos.FieldDescriptorProto field,
                                   String indent) {
        String label = getLabel(field.getLabel());
        String type  = getType(field);

        String line = indent;
        if (!label.isEmpty()) {
            line += label + " ";
        }
        line += type + " " + field.getName() + " = " + field.getNumber() + ";";
        writer.println(line);
    }

    private static void writeEnum(PrintWriter writer,
                                  DescriptorProtos.EnumDescriptorProto enumType,
                                  String indent) {
        writer.println(indent + "enum " + enumType.getName() + " {");
        for (DescriptorProtos.EnumValueDescriptorProto value : enumType.getValueList()) {
            writer.println(indent + "  " + value.getName() + " = " + value.getNumber() + ";");
        }
        writer.println(indent + "}");
        writer.println();
    }

    private static void writeService(PrintWriter writer,
                                     DescriptorProtos.ServiceDescriptorProto service) {
        writer.println("service " + service.getName() + " {");
        for (DescriptorProtos.MethodDescriptorProto method : service.getMethodList()) {
            String clientStream = method.getClientStreaming() ? "stream " : "";
            String serverStream = method.getServerStreaming() ? "stream " : "";
            writer.println("  rpc " + method.getName()
                    + " (" + clientStream + method.getInputType().replaceFirst("^\\.", "") + ")"
                    + " returns (" + serverStream + method.getOutputType()
                    .replaceFirst("^\\.", "") + ");");
        }
        writer.println("}");
        writer.println();
    }

    private static String getLabel(DescriptorProtos.FieldDescriptorProto.Label label) {
        return switch (label) {
            case LABEL_OPTIONAL -> "optional";
            case LABEL_REQUIRED -> "required";
            case LABEL_REPEATED -> "repeated";
        };
    }

    private static String getType(DescriptorProtos.FieldDescriptorProto field) {
        if (field.getType() == DescriptorProtos.FieldDescriptorProto.Type.TYPE_MESSAGE
                || field.getType() == DescriptorProtos.FieldDescriptorProto.Type.TYPE_ENUM) {
            return field.getTypeName().replaceFirst("^\\.", "");
        }
        return switch (field.getType()) {
            case TYPE_DOUBLE   -> "double";
            case TYPE_FLOAT    -> "float";
            case TYPE_INT32    -> "int32";
            case TYPE_INT64    -> "int64";
            case TYPE_UINT32   -> "uint32";
            case TYPE_UINT64   -> "uint64";
            case TYPE_SINT32   -> "sint32";
            case TYPE_SINT64   -> "sint64";
            case TYPE_FIXED32  -> "fixed32";
            case TYPE_FIXED64  -> "fixed64";
            case TYPE_SFIXED32 -> "sfixed32";
            case TYPE_SFIXED64 -> "sfixed64";
            case TYPE_BOOL     -> "bool";
            case TYPE_STRING   -> "string";
            case TYPE_BYTES    -> "bytes";
            default            -> "bytes";
        };
    }
}
