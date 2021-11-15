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
package io.ballerina.stdlib.grpc.builder.balgen;

import static io.ballerina.stdlib.grpc.builder.balgen.BalGenConstants.PACKAGE_SEPARATOR;

/**
 * Util functions which are use when generating . bal stub
 */
public class BalGenerationUtils {

    private BalGenerationUtils() {

    }

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
            case ".google.protobuf.UInt64Value":
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
                return "'any:Any";
            }
            case ".google.protobuf.Empty": {
                return null;
            }
            case ".google.protobuf.Timestamp": {
                return "time:Utc";
            }
            case ".google.protobuf.Duration": {
                return "time:Seconds";
            }
            case ".google.protobuf.Struct": {
                return "map<anydata>";
            }
            default: { // to handle structs
                return protoType.substring(protoType.lastIndexOf
                        (PACKAGE_SEPARATOR) + 1);
            }
        }
    }
}
