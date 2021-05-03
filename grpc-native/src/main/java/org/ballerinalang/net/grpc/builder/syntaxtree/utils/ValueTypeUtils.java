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

package org.ballerinalang.net.grpc.builder.syntaxtree.utils;

import org.ballerinalang.net.grpc.builder.syntaxtree.components.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Type;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.isBallerinaBasicType;

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
        if (key.equals("byte[]")) {
            typeName = "ContextBytesStream";
        } else {
            typeName = "Context" + capitalize(key) + "Stream";
        }
        Record contextStream = new Record();
        contextStream.addStreamField(key, "content");
        contextStream.addMapField(
                "headers",
                getUnionTypeDescriptorNode(
                        SYNTAX_TREE_VAR_STRING,
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
            if (key.equals("byte[]")) {
                typeName = "ContextBytes";
            } else {
                typeName = "Context" + capitalize(key);
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
                        SYNTAX_TREE_VAR_STRING,
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
