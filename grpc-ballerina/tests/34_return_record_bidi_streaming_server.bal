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

listener Listener ep34 = new (9124);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_34,
    descMap: getDescriptorMap34()
}
service "HelloWorld34" on ep34 {

    remote isolated function sayHello34(stream<SampleMsg34, error?> clientStream) returns stream<SampleMsg34, error?> {
        io:println("Connected sucessfully.");
        error? e = clientStream.forEach(isolated function(SampleMsg34 val) {
            io:println(val);
        });
        io:println("Send");
        SampleMsg34[] respArr = [
            {name: "WSO2", id: 0},
            {name: "Microsoft", id: 1},
            {name: "Facebook", id: 2},
            {name: "Google", id: 3}
        ];
        return respArr.toStream();
    }
}
