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
import ballerina/lang.runtime as runtime;
import ballerina/log;

// Server endpoint configuration
listener grpc:Listener ep3 = new (9093, {
    host: "localhost",
    secureSocket: {
        key: {
            path: KEYSTORE_PATH,
            password: "ballerina"
        },
        mutualSsl: {
            verifyClient: grpc:REQUIRE,
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            }
        },
        protocol: {
            name: grpc:TLS,
            versions: ["TLSv1.2","TLSv1.1"]
        },
        ciphers:["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
    }
});

map<ChatStringCaller> connectionsMap = {};
boolean initialized = false;

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_03_BIDIRECTIONAL_STREAMING_SERVICE,
    descMap: getDescriptorMap03BidirectionalStreamingService()
}
service "Chat" on ep3 {

    remote function chat(ChatStringCaller caller, stream<ChatMessage, error?> clientStream) returns error? {
        log:printInfo(string `${caller.getId()} connected to chat`);
        connectionsMap[caller.getId().toString()] = caller;
        initialized = true;
        checkpanic clientStream.forEach(function(ChatMessage chatMsg) {
            ChatStringCaller conn;
            string msg = string `${chatMsg.name}: ${chatMsg.message}`;
            log:printInfo("Server received message: " + msg);
            int waitCount = 0;
            while !initialized {
                runtime:sleep(1);
                log:printInfo("Waiting till connection initialize. status: " + initialized.toString());
                if waitCount > 10 {
                    break;
                }
                waitCount += 1;
            }
            foreach var [callerId, connection] in connectionsMap.entries() {
                conn = connection;
                grpc:Error? err = conn->sendString(msg);
                if err is grpc:Error {
                    log:printError("Error from Connector: " + err.message());
                } else {
                    log:printInfo("Server message to caller " + callerId + " sent successfully.");
                }
            }
        });
        string msg = string `${caller.getId()} left the chat`;
        _ = connectionsMap.remove(caller.getId().toString());
        log:printInfo("Starting client left broadcast. Connection map status");
        log:printInfo("Map length: " + connectionsMap.length().toString());
        log:printInfo(connectionsMap.toString());
        foreach var [callerId, connection] in connectionsMap.entries() {
            ChatStringCaller conn;
            conn = connection;
            grpc:Error? err = conn->sendString(msg);
            if err is grpc:Error {
                log:printError("Error from Connector: " + err.message());
            } else {
                log:printInfo("Server message to caller " + callerId + " sent successfully.");
            }
        }
    }
}
