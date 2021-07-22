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

import ballerina/test;

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithCaller() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "write" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };
    ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler.enrich(requestHeaders);

    helloWorld55Client hClient = check new ("http://localhost:9155");
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendContextString({
        content: "Hello",
        headers: requestHeaders
    });
    check strClient->complete();
    string? s = check strClient->receiveString();
    if s is () {
        test:assertFail("Expected a response");
    } else {
        test:assertEquals(s, "Hello");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithCallerUnauthenticated() returns error? {
    map<string|string[]> requestHeaders = {
        "x-id": "0987654321",
        "authorization": "bearer "
    };

    helloWorld55Client hClient = check new ("http://localhost:9155");
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendContextString({
        content: "Hello",
        headers: requestHeaders
    });
    check strClient->complete();
    string|Error? s = strClient->receiveString();
    if s is UnauthenticatedError {
        test:assertEquals(s.message(), "Failed to authenticate client");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithCallerInvalidPermission() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "read" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };
    ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler.enrich(requestHeaders);

    helloWorld55Client hClient = check new ("http://localhost:9155");
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendContextString({
        content: "Hello",
        headers: requestHeaders
    });
    check strClient->complete();
    string|Error? s = strClient->receiveString();
    if s is PermissionDeniedError {
        test:assertEquals(s.message(), "Permission denied");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithReturn() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "write" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };
    ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler.enrich(requestHeaders);

    helloWorld55Client hClient = check new ("http://localhost:9155");
    Hello55BiDiWithReturnStreamingClient strClient = check hClient->hello55BiDiWithReturn();
    check strClient->sendContextString({
        content: "Hello",
        headers: requestHeaders
    });
    check strClient->complete();
    string? s = check strClient->receiveString();
    if s is () {
        test:assertFail("Expected a response");
    } else {
        test:assertEquals(s, "Hello");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthUnary() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "write" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };
    ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler.enrich(requestHeaders);
    ContextString ctxString = {
        headers: requestHeaders,
        content: "Hello"
    };

    helloWorld55Client hClient = check new ("http://localhost:9155");
    string|Error result = hClient->hello55UnaryWithCaller(ctxString);
    if result is Error {
        test:assertFail(result.message());
    } else {
        test:assertEquals(result, ctxString.content);
    }
}

@test:Config {enable: true}
function testHello55JWTAuthUnaryUnauthenticated() returns error? {
    map<string|string[]> requestHeaders = {
        "authorization": "bearer "
    };
    ContextString ctxString = {
        headers: requestHeaders,
        content: "Hello"
    };

    helloWorld55Client hClient = check new ("http://localhost:9155");
    string|Error result = hClient->hello55UnaryWithCaller(ctxString);
    if result is Error {
        test:assertEquals(result.message(), "Failed to authenticate client");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthUnaryInvalidPermission() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "read" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };
    ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler.enrich(requestHeaders);
    ContextString ctxString = {
        headers: requestHeaders,
        content: "Hello"
    };

    helloWorld55Client hClient = check new ("http://localhost:9155");
    string|Error result = hClient->hello55UnaryWithCaller(ctxString);
    if result is Error {
        test:assertEquals(result.message(), "Permission denied");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: false}
function testHello55LdapAuth() returns error? {
    map<string|string[]> requestHeaders = {};
    CredentialsConfig config = {
        username: "alice",
        password: "alice@123"
    };

    ClientBasicAuthHandler handler = new (config);
    map<string|string[]>|ClientAuthError result = handler.enrich(requestHeaders);
    if result is ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    ContextString requestMessage = {
        content: "Hello",
        headers: requestHeaders
    };

    helloWorld55Client hClient = check new ("http://localhost:9155");
    string|Error response = hClient->hello55UnaryWithReturn(requestMessage);
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, requestMessage.content);
    }
}

@test:Config {enable: true}
function testHello55BasicAuth() returns error? {
    map<string|string[]> requestHeaders = {};

    CredentialsConfig config = {
        username: "admin",
        password: "123"
    };

    ClientBasicAuthHandler handler = new (config);
    map<string|string[]>|ClientAuthError result = handler.enrich(requestHeaders);
    if result is ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    ContextString requestMessage = {
        content: "Hello",
        headers: requestHeaders
    };

    helloWorld55Client hClient = check new ("http://localhost:9155");
    string|Error response = hClient->hello55UnaryWithReturn(requestMessage);
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, requestMessage.content);
    }
}

@test:Config {enable: true}
function testHello55OAuth2Auth() returns error? {
    map<string|string[]> requestHeaders = {};

    OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        scopes: ["write"],
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };
    ClientOAuth2Handler handler = new(config);
    map<string|string[]>|ClientAuthError result = handler->enrich(requestHeaders);
    if result is ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    ContextString requestMessage = {
        content: "Hello", headers: requestHeaders
    };

    helloWorld55Client hClient = check new ("http://localhost:9155");
    string|Error response = hClient->hello55UnaryWithReturn(requestMessage);
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, requestMessage.content);
    }
}

@test:Config {enable: true}
function testHello55JWTAuthWithEmptyScope() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };
    ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler.enrich(requestHeaders);

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255");
    ContextString requestMessage = {
        content: "Hello", headers: requestHeaders
    };
    string|Error? result = check hClient->hello55EmptyScope(requestMessage);
    if result is () {
        test:assertFail("Expected a response");
    } else {
        test:assertEquals(result, requestMessage.content);
    }
}

@test:Config {enable: false}
function testHello55LdapAuthWithEmptyScope() returns error? {
    map<string|string[]> requestHeaders = {};
    CredentialsConfig config = {
        username: "alice",
        password: "alice@123"
    };

    ClientBasicAuthHandler handler = new (config);
    map<string|string[]>|ClientAuthError result = handler.enrich(requestHeaders);
    if result is ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    ContextString requestMessage = {
        content: "Hello",
        headers: requestHeaders
    };

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255");
    string|Error response = hClient->hello55EmptyScope(requestMessage);
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, requestMessage.content);
    }
}

@test:Config {enable: true}
function testHello55BasicAuthWithEmptyScope() returns error? {
    map<string|string[]> requestHeaders = {};

    CredentialsConfig config = {
        username: "admin",
        password: "123"
    };

    ClientBasicAuthHandler handler = new (config);
    map<string|string[]>|ClientAuthError result = handler.enrich(requestHeaders);
    if result is ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    ContextString requestMessage = {
        content: "Hello",
        headers: requestHeaders
    };

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255");
    string|Error response = hClient->hello55EmptyScope(requestMessage);
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, requestMessage.content);
    }
}

@test:Config {enable: true}
function testHello55OAuth2AuthWithEmptyScope() returns error? {
    map<string|string[]> requestHeaders = {};

    OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };
    ClientOAuth2Handler handler = new(config);
    map<string|string[]>|ClientAuthError result = handler->enrich(requestHeaders);
    if result is ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    ContextString requestMessage = {
        content: "Hello", headers: requestHeaders
    };

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255");
    string|Error response = hClient->hello55EmptyScope(requestMessage);
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, requestMessage.content);
    }
}

@test:Config {enable: true}
function testHello55EmptyAuthHeader() returns error? {
    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255");
    string|Error response = hClient->hello55EmptyScope("Hello");
    if response is Error {
        test:assertEquals(response.message(), "Authorization header does not exist");
    } else {
        test:assertFail("Expected an error");
    }
}
