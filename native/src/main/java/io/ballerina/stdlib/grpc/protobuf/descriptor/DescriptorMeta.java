/*
 *  Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
package io.ballerina.stdlib.grpc.protobuf.descriptor;

import java.io.File;
import java.util.List;

/**
 * A Class which encapsulates the metadata of a descriptor.
 */
public class DescriptorMeta {

    private final String protoPath;
    private final byte[] descriptor;
    private final List<String> unusedImports;

    public DescriptorMeta(String protoPath, byte[] descriptor, List<String> unusedImports) {
        this.descriptor = descriptor;
        this.unusedImports = unusedImports;
        this.protoPath = protoPath;
    }

    public byte[] getDescriptor() {
        return descriptor;
    }

    public List<String> getUnusedImports() {
        return unusedImports;
    }

    public String getProtoName() {
        File file = new File(protoPath);
        return file.getName();
    }
}
