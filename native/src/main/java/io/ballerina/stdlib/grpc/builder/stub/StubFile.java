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
package io.ballerina.stdlib.grpc.builder.stub;

import java.util.ArrayList;
import java.util.List;

/**
 * Client Stub File definition bean class.
 *
 * @since 0.982.0
 */
public class StubFile extends AbstractStub {
    private final List<ServiceStub> stubList = new ArrayList<>();
    private final List<String> importList = new ArrayList<>();
    private final String fileName;
    
    public StubFile(String fileName) {
        this.fileName = fileName;
    }

    public String getFileName() {
        return fileName;
    }

    public void addServiceStub(ServiceStub serviceStub) {
        stubList.add(serviceStub);
    }

    public List<ServiceStub> getStubList() {
        return stubList;
    }

    public List<String> getImportList() {
        return importList;
    }

    public void addImport(String protobufImport) {
        importList.add(protobufImport);
    }
}
