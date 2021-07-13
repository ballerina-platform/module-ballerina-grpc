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
// This is client implementation for bidirectional streaming scenario

import ballerina/io;
import ballerina/lang.runtime as runtime;
import ballerina/test;


@test:Config {enable:true}
isolated function testBidiStreaming() returns Error? {
    ChatStreamingClient ep;
    ChatClient chatEp = check new ("https://localhost:9093", {
        secureSocket: {
            key: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    // Executing unary non-blocking call registering server message listener.
    var res = chatEp->chat();
    if (res is Error) {
        io:println(string `Error from Connector: ${res.message()}`);
        return;
    } else {
        ep = res;
    }
    runtime:sleep(1);
    ChatMessage mes1 = {name:"Sam", message:"Hi"};
    Error? connErr = ep->sendChatMessage(mes1);
    if (connErr is Error) {
        test:assertFail(string `Error from Connector: ${connErr.message()}`);
    }

    var responseMsg = ep->receiveString();
    if responseMsg is string {
        test:assertEquals(responseMsg, "Sam: Hi");
    } else if responseMsg is error {
        test:assertFail(msg = responseMsg.message());
    }

    ChatMessage mes2 = {name:"Sam", message:"GM"};
    connErr = ep->sendChatMessage(mes2);
    if (connErr is Error) {
        test:assertFail(string `Error from Connector: ${connErr.message()}`);
    }

    responseMsg = ep->receiveString();
    if (responseMsg is string) {
        test:assertEquals(responseMsg, "Sam: GM");
    } else if (responseMsg is Error) {
        test:assertFail(msg = responseMsg.message());
    }

    checkpanic ep->complete();
}

@test:Config {enable:true}
isolated function testBidiStreamingInvalidSecureSocketConfigs() returns Error? {
    ChatStreamingClient ep;
    ChatClient|Error result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                path: "",
                password: "ballerina"
            },
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    if result is Error {
        test:assertEquals(result.message(), "KeyStore file location must be provided for secure connection.");
    } else {
        test:assertFail("Expected an error");
    }

    result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                path: KEYSTORE_PATH,
                password: ""
            },
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    if result is Error {
        test:assertEquals(result.message(), "KeyStore password must be provided for secure connection.");
    } else {
        test:assertFail("Expected an error");
    }

    result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            cert: {
                path: "",
                password: "ballerina"
            },
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    if result is Error {
        test:assertEquals(result.message(), "TrustStore file location must be provided for secure connection.");
    } else {
        test:assertFail("Expected an error");
    }

    result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            cert: {
                path: TRUSTSTORE_PATH,
                password: ""
            },
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    if result is Error {
        test:assertEquals(result.message(), "TrustStore password must be provided for secure connection.");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable:true}
isolated function testBidiStreamingNullCertField() returns Error? {
    ChatStreamingClient ep;
    ChatClient|Error result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    if result is Error {
        string expectedError = "Need to configure 'crypto:TrustStore' or 'cert' with client SSL certificates file.";
        test:assertEquals(result.message(), expectedError);
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable:true}
isolated function testBidiStreamingWithPublicCertPrivateKey() returns Error? {
    ChatClient chatEp = check new ("https://localhost:9093", {
        secureSocket: {
            key: {
                certFile: PUBLIC_CRT_PATH,
                keyFile: PRIVATE_KEY_PATH
            },
            cert: PUBLIC_CRT_PATH,
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    ChatStreamingClient ep = check chatEp->chat();
    ChatMessage mes1 = {name:"Sam", message:"Hi"};
    Error? connErr = ep->sendChatMessage(mes1);
    if (connErr is Error) {
        test:assertFail(string `Error from Connector: ${connErr.message()}`);
    }

    string|Error? responseMsg = ep->receiveString();
    if responseMsg is string {
        test:assertEquals(responseMsg, "Sam: Hi");
    } else if responseMsg is error {
        test:assertFail(msg = responseMsg.message());
    } else {
        test:assertFail(msg = "Expected a string value");
    }
    check ep->complete();
}

@test:Config {enable:true}
isolated function testBidiStreamingWithNoCertFile() returns Error? {
    ChatStreamingClient ep;
    ChatClient|Error result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                certFile: "",
                keyFile: PRIVATE_KEY_PATH
            },
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    if result is Error {
        string expectedError = "Certificate file location must be provided for secure connection.";
        test:assertEquals(result.message(), expectedError);
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable:true}
isolated function testBidiStreamingWithNoKeyFile() returns Error? {
    ChatStreamingClient ep;
    ChatClient|Error result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                certFile: PUBLIC_CRT_PATH,
                keyFile: ""
            },
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    if result is Error {
        string expectedError = "Private key file location must be provided for secure connection.";
        test:assertEquals(result.message(), expectedError);
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable:true}
isolated function testBidiStreamingWithNoPublicCertFile() returns Error? {
    ChatStreamingClient ep;
    ChatClient|Error result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                certFile: PUBLIC_CRT_PATH,
                keyFile: PRIVATE_KEY_PATH
            },
            cert: "",
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    if result is Error {
        string expectedError = "Certificate file location must be provided for secure connection.";
        test:assertEquals(result.message(), expectedError);
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable:true}
isolated function testBidiStreamingDefaultHttpsPortWithNoService() returns Error? {
    ChatClient chatClient = check new ("https://localhost", {
        secureSocket: {
            key: {
                certFile: PUBLIC_CRT_PATH,
                keyFile: PRIVATE_KEY_PATH
            },
            cert: PUBLIC_CRT_PATH,
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    ChatStreamingClient strClient = check chatClient->chat();
    ChatMessage mes1 = {name:"Sam", message:"Hi"};
    Error? connErr = strClient->sendChatMessage(mes1);
    if (connErr is Error) {
        test:assertFail(string `Error from Connector: ${connErr.message()}`);
    }
    string|Error? res = strClient->receiveString();
    if (res is Error) {
        test:assertTrue(res.message().startsWith("Connection refused: "));
    } else {
        test:assertFail(msg = "Expected an error");
    }
}
