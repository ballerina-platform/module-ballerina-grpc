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
        customClaims: {"scope": "write"},
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

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendString("Hello");
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
        customClaims: {"scope": "read"},
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

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendString("Hello");
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
        customClaims: {"scope": "write"},
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
    ClientSelfSignedJwtAuthHandler handler = new (config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler.enrich(requestHeaders);

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55BiDiWithReturnStreamingClient strClient = check hClient->hello55BiDiWithReturn();
    check strClient->sendString("Hello");
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
        customClaims: {"scope": "write"},
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

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|Error result = hClient->hello55UnaryWithCaller("Hello");
    if result is Error {
        test:assertFail(result.message());
    } else {
        test:assertEquals(result, "Hello");
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
        customClaims: {"scope": "read"},
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

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|Error result = hClient->hello55UnaryWithCaller("Hello");
    if result is Error {
        test:assertEquals(result.message(), "Permission denied");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testHello55LdapAuth() returns error? {

    if !isWindowsEnvironment() {
        service object {} helloWorld55 = @ServiceConfig {auth: [ldapUserStoreconfig55WithScopes]} 
        @ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_55, descMap: getDescriptorMap55()} 
        service object {

            remote function hello55BiDiWithCaller(HelloWorld55StringCaller caller, 
            stream<string, Error?> clientStream) returns error? {
                record {|string value;|}|Error? result = clientStream.next();
                result = clientStream.next();
                check caller->sendString("Hello");
                check caller->complete();
            }

            remote function hello55BiDiWithReturn(stream<string, Error?> clientStream) 
            returns stream<string, Error?>|error? {
                return clientStream;
            }

            remote function hello55UnaryWithCaller(HelloWorld55StringCaller caller, string value) returns error? {
                check caller->sendString(value);
                check caller->complete();
            }

            remote function hello55UnaryWithReturn(string value) returns string|error? {
                return value;
            }

            remote function hello55ServerStreaming(HelloWorld55StringCaller caller, string value) returns error? {
                check caller->sendString(value + " 1");
                check caller->sendString(value + " 2");
                check caller->complete();
            }

            remote function hello55ClientStreaming(HelloWorld55StringCaller caller, stream<string, error?> clientStream) returns error? {
                var value1 = clientStream.next();
                var value2 = clientStream.next();
                if value1 is error || value1 is () || value2 is error || value2 is () {
                    check caller->sendError(error Error("Invalid request"));
                } else {
                    check caller->sendString(value1["value"] + " " + value2["value"]);
                }
                check caller->complete();
            }
        };
        check ep55WithLdapAndScopes.attach(helloWorld55, "helloWorld55");
        check ep55WithLdapAndScopes.'start();
        CredentialsConfig config = {
            username: "alice",
            password: "alice@123"
        };

        helloWorld55Client hClient = check new ("http://localhost:9256", {auth: config});
        string|Error response = hClient->hello55UnaryWithReturn("Hello");
        if response is Error {
            test:assertFail(response.message());
        } else {
            test:assertEquals(response, "Hello");
        }
        check ep55WithLdapAndScopes.immediateStop();
    }
}

@test:Config {enable: true}
function testHello55BasicAuth() returns error? {
    CredentialsConfig config = {
        username: "admin",
        password: "123"
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|Error response = hClient->hello55UnaryWithReturn("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55OAuth2Auth() returns error? {
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

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|Error response = hClient->hello55UnaryWithReturn("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
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

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string|Error? result = check hClient->hello55EmptyScope("Hello");
    if result is () {
        test:assertFail("Expected a response");
    } else {
        test:assertEquals(result, "Hello");
    }
}

@test:Config {enable: false}
function testHello55LdapAuthWithEmptyScope() returns error? {
    if !isWindowsEnvironment() {
        service object {} helloWorld55EmptyScope = @ServiceConfig {auth: [ldapUserStoreconfig55EmptyScope]} 
        @ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_55, descMap: getDescriptorMap55()} 
        service object {

            remote function hello55EmptyScope(HelloWorld55EmptyScopeStringCaller caller, string value) returns error? {
                check caller->sendString(value);
                check caller->complete();
            }
        };
        check ep55WithLdapAndEmptyScope.attach(helloWorld55EmptyScope, "helloWorld55EmptyScope");
        check ep55WithLdapAndEmptyScope.'start();

        CredentialsConfig config = {
            username: "alice",
            password: "alice@123"
        };
        helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9257", {auth: config});
        string|Error response = hClient->hello55EmptyScope("Hello");
        if response is Error {
            test:assertFail(response.message());
        } else {
            test:assertEquals(response, "Hello");
        }
        check ep55WithLdapAndEmptyScope.immediateStop();
    }
}

@test:Config {enable: true}
function testHello55BasicAuthWithEmptyScope() returns error? {
    CredentialsConfig config = {
        username: "admin",
        password: "123"
    };

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string|Error response = hClient->hello55EmptyScope("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55OAuth2AuthWithEmptyScope() returns error? {
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

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string|Error response = hClient->hello55EmptyScope("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55ServerStreamingOAuth2Auth() returns error? {
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

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    stream<string, Error?>|Error response = hClient->hello55ServerStreaming("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        var value1 = response.next();
        var value2 = response.next();
        if value1 is Error || value2 is Error {
            test:assertFail("Error occured");
        } else if value1 is () || value2 is () {
            test:assertFail("Expected a non null response");
        } else {
            test:assertEquals(value1["value"], "Hello 1");
            test:assertEquals(value2["value"], "Hello 2");
        }
    }
}

@test:Config {enable: true}
function testHello55ClientStreamingOAuth2Auth() returns error? {
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

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55ClientStreamingStreamingClient sClient = check hClient->hello55ClientStreaming();
    check sClient->sendString("Hello");
    check sClient->sendString("World");
    check sClient->complete();

    string|Error? response = sClient->receiveString();
    if response is Error {
        test:assertFail(response.message());
    } else if response is () {
        test:assertFail("Expected a response");
    } else {
        test:assertEquals(response, "Hello World");
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
