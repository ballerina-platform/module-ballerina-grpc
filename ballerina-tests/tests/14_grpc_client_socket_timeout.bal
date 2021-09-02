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

import ballerina/grpc;
import ballerina/io;
import ballerina/lang.runtime as runtime;

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_14_GRPC_CLIENT_SOCKET_TIMEOUT,
    descMap: getDescriptorMap14GrpcClientSocketTimeout()
}
service "HelloWorld14" on new grpc:Listener(9104) {

    isolated remote function hello (HelloWorld14StringCaller caller, string name,
                             map<string|string[]> headers) {
        string message = "Hello " + name;
        runtime:sleep(2);
        // Sends response message with headers.
        grpc:Error? err = caller->sendString(message);
        if err is grpc:Error {
            io:println("Error from Connector: " + err.message());
        }

        // Sends `completed` notification to caller.
        checkpanic caller->complete();
    }
}
