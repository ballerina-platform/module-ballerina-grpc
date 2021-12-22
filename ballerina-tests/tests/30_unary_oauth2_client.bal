// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/test;
import ballerina/protobuf.types.wrappers;

@test:Config {enable: true}
isolated function testStringValueReturnWithOAuth2() returns grpc:Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    grpc:OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        scopes: ["token-scope1", "token-scope2"],
        clientConfig: {
            secureSocket: {
                cert: {
                    path: TRUSTSTORE_PATH,
                    password: "ballerina"
                }
            }
        }
    };
    grpc:ClientOAuth2Handler handler = new (config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler->enrich(requestHeaders);
    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    string response = check helloWorldEp->testStringValueReturn(requestMessage);
    test:assertEquals(response, "Hello WSO2");
}

@test:Config {enable: true}
isolated function testStringValueReturnWithOAuth2PasswordGrantConfig() returns grpc:Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    grpc:OAuth2PasswordGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        username: "user",
        password: "ballerina",
        scopes: ["token-scope1", "token-scope2"],
        clientConfig: {
            secureSocket: {
                cert: {
                    path: TRUSTSTORE_PATH,
                    password: "ballerina"
                }
            }
        }
    };
    grpc:ClientOAuth2Handler handler = new (config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler->enrich(requestHeaders);
    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    string response = check helloWorldEp->testStringValueReturn(requestMessage);
    test:assertEquals(response, "Hello WSO2");
}

@test:Config {enable: true}
isolated function testStringValueReturnWithOAuth2RefreshTokenGrantConfig() returns grpc:Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    grpc:OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        scopes: ["token-scope1", "token-scope2"],
        clientConfig: {
            secureSocket: {
                cert: {
                    path: TRUSTSTORE_PATH,
                    password: "ballerina"
                }
            }
        }
    };
    grpc:ClientOAuth2Handler handler = new (config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler->enrich(requestHeaders);
    string oldToken = "";
    string|string[] headerValue = requestHeaders.get("authorization");
    if headerValue is string {
        oldToken = headerValue;
    } else if headerValue.length() > 0 {
        oldToken = headerValue[0];
    }

    grpc:OAuth2RefreshTokenGrantConfig refreshConfig = {
        refreshUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        refreshToken: oldToken,
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        scopes: ["token-scope1", "token-scope2"],
        clientConfig: {
            secureSocket: {
                cert: {
                    path: TRUSTSTORE_PATH,
                    password: "ballerina"
                }
            }
        }
    };

    grpc:ClientOAuth2Handler refreshHandler = new (refreshConfig);
    requestHeaders = check refreshHandler->enrich(requestHeaders);
    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    string response = check helloWorldEp->testStringValueReturn(requestMessage);
    test:assertEquals(response, "Hello WSO2");
}

@test:Config {enable: true}
isolated function testStringValueReturnWithOAuth2JwtBearerGrantConfig() returns grpc:Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    grpc:OAuth2JwtBearerGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        assertion: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        scopes: ["token-scope1", "token-scope2"],
        clientConfig: {
            secureSocket: {
                cert: {
                    path: TRUSTSTORE_PATH,
                    password: "ballerina"
                }
            }
        }
    };
    grpc:ClientOAuth2Handler handler = new (config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler->enrich(requestHeaders);
    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    string response = check helloWorldEp->testStringValueReturn(requestMessage);
    test:assertEquals(response, "Hello WSO2");
}

@test:Config {enable: true}
isolated function testStringValueReturnWithOAuth2NoScope() returns grpc:Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    grpc:OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        scopes: ["token-scope1", "token-scope2"],
        clientConfig: {
            secureSocket: {
                cert: {
                    path: TRUSTSTORE_PATH,
                    password: "ballerina"
                }
            }
        }
    };
    grpc:ClientOAuth2Handler handler = new (config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler->enrich(requestHeaders);
    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    string response = check helloWorldEp->testStringValueNoScope(requestMessage);
    test:assertEquals(response, "Hello WSO2");
}

@test:Config {enable: true}
isolated function testStringValueReturnWithOAuth2WithInvalidScopeKey() returns grpc:Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    grpc:OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        scopes: ["token-scope1", "token-scope2"],
        clientConfig: {
            secureSocket: {
                cert: {
                    path: TRUSTSTORE_PATH,
                    password: "ballerina"
                }
            }
        }
    };
    grpc:ClientOAuth2Handler handler = new (config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler->enrich(requestHeaders);

    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "Invalid", headers: requestHeaders};
    string|grpc:Error response = helloWorldEp->testStringValueNegative(requestMessage);
    test:assertTrue(response is grpc:Error);
    test:assertEquals((<grpc:Error>response).message(), "Permission denied");
}

@test:Config {enable: true}
isolated function testStringValueReturnWithOAuth2EmptyAuthHeader() returns grpc:Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    map<string|string[]> requestHeaders = {
        "x-id": "0987654321",
        "authorization": ""
    };
    wrappers:ContextString requestMessage = {content: "scp", headers: requestHeaders};
    string|grpc:Error response = helloWorldEp->testStringValueNegative(requestMessage);
    test:assertTrue(response is grpc:Error);
    test:assertEquals((<grpc:Error>response).message(), "Empty authentication header.");
}

@test:Config {enable: true}
isolated function testStringValueReturnWithOAuth2InvalidAuthHeader() returns grpc:Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    map<string|string[]> requestHeaders = {
        "x-id": "0987654321",
        "authorization": "Bearer invalid"
    };
    wrappers:ContextString requestMessage = {content: "scp", headers: requestHeaders};
    string|grpc:Error response = helloWorldEp->testStringValueNegative(requestMessage);
    test:assertTrue(response is grpc:Error);
    test:assertEquals((<grpc:Error>response).message(), "Unauthenticated");
}

@test:Config {enable: true}
isolated function testStringValueReturnWithOAuth2InvalidAuthHeaderFormat() returns grpc:Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    map<string|string[]> requestHeaders = {
        "x-id": "0987654321",
        "authorization": "Bearer  invalid"
    };
    wrappers:ContextString requestMessage = {content: "scp", headers: requestHeaders};
    string|grpc:Error response = helloWorldEp->testStringValueNegative(requestMessage);
    test:assertTrue(response is grpc:Error);
    test:assertEquals((<grpc:Error>response).message(), "Unauthenticated");
}
