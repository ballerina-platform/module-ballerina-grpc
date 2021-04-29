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

/**
 * Utility functions common to Syntax tree generation.
 *
 * @since 0.8.0
 */
public class CommonUtils {

    public static String capitalize(String name) {
        return name.substring(0, 1).toUpperCase() + name.substring(1);
    }

    public static String capitalizeFirstLetter(String name) {
        return name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
    }

    public static String toPascalCase(String str) {
        StringBuilder pascalCaseOutput = new StringBuilder();
        for (String s : str.split("_")) {
            s = s.replaceAll("[^a-zA-Z0-9]", "");
            pascalCaseOutput.append(capitalize(s));
        }
        return pascalCaseOutput.toString();
    }

    public static boolean isBallerinaBasicType(String type) {
        switch (type) {
            case "string" :
            case "int" :
            case "float" :
            case "boolean" :
            case "bytes" :
                return true;
            default:
                return false;
        }
    }
}
