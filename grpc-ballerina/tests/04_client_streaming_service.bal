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
// This is server implementation for client streaming scenario

import ballerina/log;


// Server endpoint configuration
listener Listener ep4 = new (9094);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_4,
    descMap: getDescriptorMap4()
}
service "HelloWorld7" on ep4 {

    remote isolated function lotsOfGreetings(HelloWorld7StringCaller caller, stream<string, error?>clientStream) {
        log:printInfo("connected sucessfully.");
        error? e = clientStream.forEach(isolated function(string name) {
            log:printInfo("greet received: " + name);
        });
        if (e is ()) {
            log:printInfo("Server Response");
            Error? err = caller->sendString("Ack");
            if (err is Error) {
                log:printError("Error from Connector: " + err.message());
            } else {
                log:printInfo("Server send response : Ack");
            }
        } else {
            log:printError("Something unexpected happens at server :: " + e.message());
        }
    }
}
