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

import org.ballerinalang.net.grpc.builder.stub.EnumField;
import org.ballerinalang.net.grpc.builder.stub.EnumMessage;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Enum;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Type;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;

public class Types {

    public static Type getValueTypeStream(String name) {
        String typeName = "Context" + name.substring(0,1).toUpperCase() + name.substring(1) + "Stream";
        Record contextStringStream = new Record();
        contextStringStream.addStreamField("content", name);
        contextStringStream.addMapField("headers", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING,
                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY));
        return new Type(true, typeName, contextStringStream.getRecordTypeDescriptorNode());
    }

    public static Type getValueType(String key) {
        String typeName = "Context" + key.substring(0,1).toUpperCase() + key.substring(1);
        Record contextString = new Record();
        if (key.equals("string")) {
            contextString.addStringField("content");
        } else {
            contextString.addCustomField("content", key);
        }
        contextString.addMapField("headers", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING,
                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY));
        return new Type(true, typeName, contextString.getRecordTypeDescriptorNode());
    }

    public static Enum getEnumType(EnumMessage enumMessage) {
        Enum enumMsg = new Enum(enumMessage.getMessageName(), true);
        for (EnumField field : enumMessage.getFieldList()) {
            enumMsg.addMember(Enum.getEnumMemberNode(field.getName()));
        }
        return enumMsg;
    }
}
