/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package io.ballerina.stdlib.grpc.builder.syntaxtree.utils;

import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Record;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Type;
import io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.isBallerinaBasicType;

/**
 * Utility functions related to ValueType.
 *
 * @since 0.8.0
 */
public class ValueTypeUtils {

    private ValueTypeUtils() {

    }

    public static Type getValueTypeStream(String key) {
        String typeName;
        switch (key) {
            case "byte[]":
                typeName = "ContextBytesStream";
                break;
            case "time:Utc":
                typeName = "ContextTimestampStream";
                break;
            case "time:Seconds":
                typeName = "ContextDurationStream";
                break;
            case "map<anydata>":
                typeName = "ContextStructStream";
                break;
            default:
                typeName = "Context" + capitalize(key) + "Stream";
                break;
        }
        Record contextStream = new Record();
        contextStream.addStreamField(key, "content");
        contextStream.addMapField(
                "headers",
                getUnionTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING,
                        SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY
                )
        );
        return new Type(
                true,
                typeName,
                contextStream.getRecordTypeDescriptorNode()
        );
    }

    public static Type getValueType(String key) {
        String typeName;
        Record contextString = new Record();
        if (key == null) {
            typeName = "ContextNil";
        } else {
            switch (key) {
                case "byte[]":
                    typeName = "ContextBytes";
                    break;
                case "time:Utc":
                    typeName = "ContextTimestamp";
                    break;
                case "time:Seconds":
                    typeName = "ContextDuration";
                    break;
                case "map<anydata>":
                    typeName = "ContextStruct";
                    break;
                default:
                    typeName = "Context" + capitalize(key);
                    break;
            }
            if (isBallerinaBasicType(key)) {
                contextString.addBasicField(key, "content");
            } else {
                contextString.addCustomField(key, "content");
            }
        }
        contextString.addMapField(
                "headers",
                getUnionTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING,
                        SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY
                )
        );
        return new Type(
                true,
                typeName,
                contextString.getRecordTypeDescriptorNode()
        );
    }
}
