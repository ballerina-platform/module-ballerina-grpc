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

/**
 * Utility functions related to Enum.
 *
 * @since 0.8.0
 */
public class EnumUtils {

    private EnumUtils() {

    }

    public static Enum getEnum(EnumMessage enumMessage) {
        Enum enumMsg = new Enum(enumMessage.getMessageName());
        for (EnumField field : enumMessage.getFieldList()) {
            enumMsg.addMember(Enum.getEnumMemberNode(field.getName()));
        }
        return enumMsg;
    }
}
