// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_15,
    descMap: getDescriptorMap15()
}
service "OneofFieldService" on new Listener(9105) {

    isolated remote function hello(OneofFieldServiceResponse1Caller caller, Request1 value) {
        string? request = "";
        if (value?.first_name is string) {
            request = value?.first_name;
        } else {
            request = value?.last_name;
        }
        Response1 response = {message: "Hello " + <string>request};
        io:println(response);
        checkpanic caller->sendResponse1(response);
        checkpanic caller->complete();
    }

    isolated remote function testOneofField(OneofFieldServiceZZZCaller caller, ZZZ req) {
        checkpanic caller->sendZZZ(req);
        checkpanic caller->complete();
    }
}
