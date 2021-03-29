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

public client class ChatStringCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendString(string response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextString(ContextString response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public type ContextChatMessage record {|
    ChatMessage content;
    map<string|string[]> headers;
|};

public type ContextChatMessageStream record {|
    stream<ChatMessage, error?> content;
    map<string|string[]> headers;
|};

public type ChatMessage record {|
    string name = "";
    string message = "";

|};

const string ROOT_DESCRIPTOR_3 = "0A2830335F6269646972656374696F6E616C5F73747265616D696E675F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223B0A0B436861744D65737361676512120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765323E0A044368617412360A0463686174120C2E436861744D6573736167651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33";
isolated function getDescriptorMap3() returns map<string> {
    return {
        "03_bidirectional_streaming_service.proto":"0A2830335F6269646972656374696F6E616C5F73747265616D696E675F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223B0A0B436861744D65737361676512120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765323E0A044368617412360A0463686174120C2E436861744D6573736167651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C7565427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
