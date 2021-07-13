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
// This is server implementation for bidirectional streaming scenario

import ballerina/lang.runtime as runtime;
import ballerina/log;

// Server endpoint configuration
listener Listener ep3 = new (9093, {
      host: "localhost",
      secureSocket: {
          key: {
              path: KEYSTORE_PATH,
              password: "ballerina"
          },
          mutualSsl: {
              verifyClient: REQUIRE,
              cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
              }
          },
          protocol: {
              name: TLS,
              versions: ["TLSv1.2","TLSv1.1"]
          },
          ciphers:["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
      }
  });

@tainted map<ChatStringCaller> connectionsMap = {};
boolean initialized = false;

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_3,
    descMap: getDescriptorMap3()
}
service "Chat" on ep3 {

    remote function chat(ChatStringCaller caller, stream<ChatMessage, error?> clientStream) {
        log:printInfo(string `${caller.getId()} connected to chat`);
        connectionsMap[caller.getId().toString()] = caller;
        log:printInfo("Client registration completed. Connection map status");
        log:printInfo("Map length: " + connectionsMap.length().toString());
        log:printInfo(connectionsMap.toString());
        initialized = true;
        error? e = clientStream.forEach(function(ChatMessage chatMsg) {
            ChatStringCaller conn;
            string msg = string `${chatMsg.name}: ${chatMsg.message}`;
            log:printInfo("Server received message: " + msg);
            int waitCount = 0;
            while(!initialized) {
                runtime:sleep(1);
                log:printInfo("Waiting till connection initialize. status: " + initialized.toString());
                if (waitCount > 10) {
                    break;
                }
                waitCount += 1;
            }
            log:printInfo("Starting message broadcast. Connection map status");
            log:printInfo("Map length: " + connectionsMap.length().toString());
            log:printInfo(connectionsMap.toString());
            foreach var [callerId, connection] in connectionsMap.entries() {
                conn = connection;
                Error? err = conn->sendString(msg);
                if (err is Error) {
                    log:printError("Error from Connector: " + err.message());
                } else {
                    log:printInfo("Server message to caller " + callerId + " sent successfully.");
                }
            }
        });
        if (e is ()) {
            string msg = string `${caller.getId()} left the chat`;
            log:printInfo(msg);
            var v = connectionsMap.remove(caller.getId().toString());
            log:printInfo("Starting client left broadcast. Connection map status");
            log:printInfo("Map length: " + connectionsMap.length().toString());
            log:printInfo(connectionsMap.toString());
            foreach var [callerId, connection] in connectionsMap.entries() {
                ChatStringCaller conn;
                conn = connection;
                Error? err = conn->sendString(msg);
                if (err is Error) {
                    log:printError("Error from Connector: " + err.message());
                } else {
                    log:printInfo("Server message to caller " + callerId + " sent successfully.");
                }
            }
        } else {
            log:printError("Error from Connector: " + e.message());
        }
    }
}
