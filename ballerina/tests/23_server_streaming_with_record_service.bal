// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/log;

listener Listener helloWorldStreamingep = new (9113);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_23,
    descMap: getDescriptorMap23()
}
service "helloWorldServerStreaming" on helloWorldStreamingep {

    isolated remote function lotsOfReplies(HelloWorldServerStreamingHelloResponseCaller caller, HelloRequest value) {
        log:printInfo("Server received hello from " + value.name);
        string[] greets = ["Hi", "Hey", "GM"];

        foreach string greet in greets {
            string message = greet + " " + value.name;
            HelloResponse msg = {message: message};
            Error? err = caller->sendHelloResponse(msg);
            if (err is Error) {
                log:printError("Error from Connector: " + err.message());
            } else {
                log:printInfo("Send reply: " + msg.toString());
            }
        }

        Error? result = caller->complete();
        if (result is Error) {
            log:printError("Error in sending completed notification to caller",
                'error = result);
        }
    }
}
