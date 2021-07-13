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
// This is server implementation for server streaming scenario

import ballerina/io;

// Server endpoint configuration
listener Listener ep6 = new (9096);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_6,
    descMap: getDescriptorMap6()
}
service "HelloWorld45" on ep6 {

    isolated remote function lotsOfReplies(HelloWorld45StringCaller caller, string name) {
        io:println("Server received hello from " + name);
        string[] greets = ["Hi", "Hey", "GM"];
        foreach var greet in greets {
            Error? err = caller->sendString(greet + " " + name);
            if (err is Error) {
                io:println("Error from Connector: " + err.message());
            } else {
                io:println("send reply: " + greet + " " + name);
            }
        }
        // Once all messages are sent, server send complete message to notify the client, I’m done.
        checkpanic caller->complete();
        io:println("send all responses sucessfully.");
    }
}
