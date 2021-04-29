// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;

listener Listener ep33 = new (9123);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_33,
    descMap: getDescriptorMap33()
}
service "HelloWorld33" on ep33 {
    remote isolated function sayHello(stream<SampleMsg33, error?> clientStream) returns ContextSampleMsg33 {
        io:println("Connected sucessfully.");
        error? e = clientStream.forEach(isolated function(SampleMsg33 val) {
            io:println(val);
        });
        if (e is ()) {
            SampleMsg33 response = {name: "WSO2", id: 1};
            return {content: response, headers: {zzz: "yyy"}};
        } else {
            SampleMsg33 errResponse = {name: "", id: 0};
            return {content: errResponse, headers: {zzz: "yyy"}};
        }
    }
}
