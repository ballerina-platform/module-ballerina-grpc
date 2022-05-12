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
import ballerina/test;

@test:Config {enable: true}
isolated function testBidiStreaming() returns grpc:Error? {
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
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    // Executing unary non-blocking call registering server message listener.
    ChatStreamingClient ep = check chatEp->chat();
    runtime:sleep(1);
    ChatMessage mes1 = {name:"Sam", message:"Hi"};
    check ep->sendChatMessage(mes1);

    string? responseMsg = check ep->receiveString();
    test:assertTrue(responseMsg is string);
    test:assertEquals((<string>responseMsg), "Sam: Hi");

    ChatMessage mes2 = {name:"Sam", message:"GM"};
    check ep->sendChatMessage(mes2);

    responseMsg = check ep->receiveString();
    test:assertTrue(responseMsg is string);
    test:assertEquals(<string>responseMsg, "Sam: GM");

    check ep->complete();
}

@test:Config {enable: true}
isolated function testBidiStreamingInvalidSecureSocketConfigs() returns grpc:Error? {
    ChatClient|grpc:Error result = new ("https://localhost:9093", {
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
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "KeyStore file location must be provided for secure connection.");

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
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "KeyStore password must be provided for secure connection.");

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
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "TrustStore file location must be provided for secure connection.");

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
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "TrustStore password must be provided for secure connection.");
}

@test:Config {enable: true}
isolated function testBidiStreamingNullCertField() returns grpc:Error? {
    ChatClient|grpc:Error result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            protocol:{
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "Need to configure cert with client SSL certificates file");
}

@test:Config {enable: true}
isolated function testBidiStreamingWithPublicCertPrivateKey() returns grpc:Error? {
    ChatClient chatEp = check new ("https://localhost:9093", {
        secureSocket: {
            key: {
                certFile: PUBLIC_CRT_PATH,
                keyFile: PRIVATE_KEY_PATH
            },
            cert: PUBLIC_CRT_PATH,
            protocol:{
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    ChatStreamingClient ep = check chatEp->chat();
    ChatMessage mes1 = {name:"Sam", message:"Hi"};
    check ep->sendChatMessage(mes1);

    string? responseMsg = check ep->receiveString();
    test:assertTrue(responseMsg is string);
    test:assertEquals(<string>responseMsg, "Sam: Hi");
    check ep->complete();
}

@test:Config {enable: true}
isolated function testBidiStreamingWithNoCertFile() returns grpc:Error? {
    ChatClient|grpc:Error result = new ("https://localhost:9093", {
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
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "Certificate file location must be provided for secure connection.");
}

@test:Config {enable: true}
isolated function testBidiStreamingWithNoKeyFile() returns grpc:Error? {
    ChatClient|grpc:Error result = new ("https://localhost:9093", {
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
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "Private key file location must be provided for secure connection.");
}

@test:Config {enable: true}
isolated function testBidiStreamingWithNoPublicCertFile() returns grpc:Error? {
    ChatClient|grpc:Error result = new ("https://localhost:9093", {
        secureSocket: {
            key: {
                certFile: PUBLIC_CRT_PATH,
                keyFile: PRIVATE_KEY_PATH
            },
            cert: "",
            protocol:{
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "Certificate file location must be provided for secure connection.");
}

@test:Config {enable: true}
isolated function testBidiStreamingDefaultHttpsPortWithNoService() returns grpc:Error? {
    if !isWindowsEnvironment() {
        ChatClient chatClient = check new ("https://localhost", {
            secureSocket: {
                key: {
                    certFile: PUBLIC_CRT_PATH,
                    keyFile: PRIVATE_KEY_PATH
                },
                cert: PUBLIC_CRT_PATH,
                protocol:{
                    name: grpc:TLS,
                    versions: ["TLSv1.2", "TLSv1.1"]
                },
                ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
            }
        });
        ChatStreamingClient strClient = check chatClient->chat();
        ChatMessage mes1 = {name:"Sam", message:"Hi"};
        check strClient->sendChatMessage(mes1);

        string|grpc:Error? err = strClient->receiveString();
        test:assertTrue(err is grpc:Error);
        test:assertTrue((<grpc:Error>err).message().startsWith("Connection refused: "));
    }
}
