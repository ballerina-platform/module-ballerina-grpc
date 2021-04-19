/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.ballerinalang.net.grpc.builder.balgen;

import java.util.Locale;

import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.PACKAGE_SEPARATOR;

/**
 * Util functions which are use when generating . bal stub
 */
public class BalGenerationUtils {
    
    /**
     * Convert byte array to readable byte string.
     *
     * @param data byte array of proto file
     * @return readable string of byte array
     */
    public static String bytesToHex(byte[] data) {
        
        char[] hexChars = new char[data.length * 2];
        for (int j = 0; j < data.length; j++) {
            int v = data[j] & 0xFF;
            hexChars[j * 2] = "0123456789ABCDEF".toCharArray()[v >>> 4];
            hexChars[j * 2 + 1] = "0123456789ABCDEF".toCharArray()[v & 0x0F];
        }
        return new String(hexChars);
    }

    /**
     * This function returns the ballerina data type which is mapped to  protobuf data type.
     *
     * @param protoType .proto data type
     * @return Ballerina data type.
     */
    public static String getMappingBalType(String protoType) {
        switch (protoType) {
            case ".google.protobuf.DoubleValue":
            case ".google.protobuf.FloatValue": {
                return "float";
            }
            case ".google.protobuf.Int32Value":
                return "int";
            case ".google.protobuf.Int64Value":
            case ".google.protobuf.UInt64Value": {
                return "int";
            }
            case ".google.protobuf.UInt32Value": {
                return "int";
            }
            case ".google.protobuf.BoolValue": {
                return "boolean";
            }
            case ".google.protobuf.StringValue": {
                return "string";
            }
            case ".google.protobuf.BytesValue": {
                return "byte[]";
            }
            case ".google.protobuf.Any": {
                return "anydata";
            }
            case ".google.protobuf.Empty": {
                return null;
            }
            default: { // to handle structs
                return protoType.substring(protoType.lastIndexOf
                        (PACKAGE_SEPARATOR) + 1);
            }
        }
    }

    /**
     * This function returns camelcase value of the input string.
     *
     * @param name string value
     * @return camelcase value
     */
    public static String toCamelCase(String name) {
        if (name == null) {
            return null;
        }
        String[] parts = name.split("_");
        StringBuilder camelCaseString = new StringBuilder();
        for (String part : parts) {
            camelCaseString.append(part.substring(0, 1).toUpperCase(Locale.ENGLISH)).append(part.substring(1)
                    .toLowerCase(Locale.ENGLISH));
        }
        return camelCaseString.toString();
    }

    public static String toPascalCase(String name) {
        if (name == null) {
            return null;
        }
        return name.substring(0, 1).toUpperCase() + name.substring(1);
    }

    /**
     * This function checks if the input type is a primitive type or not.
     *
     * @param inputType .proto data type
     * @return true or false.
     */
    public static boolean checkPrimitiveType(String inputType) {
        switch (inputType) {
            case "string":
            case "int":
            case "float":
            case "boolean":
            case "byte[]": {
                return true;
            }
            default: { // for null and structs
                return false;
            }
        }
    }
}
