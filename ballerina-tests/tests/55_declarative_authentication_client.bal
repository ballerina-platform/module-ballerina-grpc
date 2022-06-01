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
function testHello55JWTAuthBiDiWithCaller() returns error? {
    grpc:JwtIssuerConfig config = {
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

    HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendString("Hello");
    check strClient->complete();
    string? s = check strClient->receiveString();
    test:assertTrue(s is string);
    test:assertEquals(<string>s, "Hello");
}

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithCallerUnauthenticated() returns error? {
    map<string|string[]> requestHeaders = {
        "x-id": "0987654321",
        "authorization": "bearer "
    };

    HelloWorld55Client hClient = check new ("http://localhost:9155");
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendContextString({
        content: "Hello",
        headers: requestHeaders
    });
    check strClient->complete();
    string|grpc:Error? s = strClient->receiveString();
    test:assertTrue(s is grpc:UnauthenticatedError);
    test:assertEquals((<grpc:UnauthenticatedError>s).message(), "Failed to authenticate client");
}

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithCallerInvalidPermission() returns error? {
    grpc:JwtIssuerConfig config = {
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

    HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendString("Hello");
    check strClient->complete();
    string|grpc:Error? s = strClient->receiveString();
    test:assertTrue(s is grpc:PermissionDeniedError);
    test:assertEquals((<grpc:PermissionDeniedError>s).message(), "Permission denied");
}

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithReturn() returns error? {
    grpc:JwtIssuerConfig config = {
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
    grpc:ClientSelfSignedJwtAuthHandler handler = new (config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler.enrich(requestHeaders);

    HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55BiDiWithReturnStreamingClient strClient = check hClient->hello55BiDiWithReturn();
    check strClient->sendString("Hello");
    check strClient->complete();
    string? s = check strClient->receiveString();
    test:assertTrue(s is string);
    test:assertEquals(<string>s, "Hello");
}

@test:Config {enable: true}
function testHello55JWTAuthUnary() returns grpc:Error? {
    grpc:JwtIssuerConfig config = {
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

    HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string result = check hClient->hello55UnaryWithCaller("Hello");
    test:assertEquals(result, "Hello");
}

@test:Config {enable: true}
function testHello55JWTAuthUnaryUnauthenticated() returns error? {
    map<string|string[]> requestHeaders = {
        "authorization": "bearer "
    };
    wrappers:ContextString ctxString = {
        headers: requestHeaders,
        content: "Hello"
    };

    HelloWorld55Client hClient = check new ("http://localhost:9155");
    string|grpc:Error result = hClient->hello55UnaryWithCaller(ctxString);
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "Failed to authenticate client");
}

@test:Config {enable: true}
function testHello55JWTAuthUnaryInvalidPermission() returns error? {
    grpc:JwtIssuerConfig config = {
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

    HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|grpc:Error result = hClient->hello55UnaryWithCaller("Hello");
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "Permission denied");
}

@test:Config {enable: true}
function testHello55LdapAuth() returns error? {

    if !isWindowsEnvironment() {
        grpc:CredentialsConfig config = {
            username: "alice",
            password: "alice@123"
        };

        HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
        string response = check hClient->hello55UnaryWithReturn("Hello");
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55BasicAuth() returns grpc:Error? {
    grpc:CredentialsConfig config = {
        username: "admin",
        password: "123"
    };

    HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string response = check hClient->hello55UnaryWithReturn("Hello");
    test:assertEquals(response, "Hello");
}

@test:Config {enable: true}
function testHello55OAuth2Auth() returns grpc:Error? {
    grpc:OAuth2ClientCredentialsGrantConfig config = {
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

    HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string response = check hClient->hello55UnaryWithReturn("Hello");
    test:assertEquals(response, "Hello");
}

@test:Config {enable: true}
function testHello55JWTAuthWithEmptyScope() returns error? {
    grpc:JwtIssuerConfig config = {
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

    HelloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string? result = check hClient->hello55EmptyScope("Hello");
    test:assertTrue(result is string);
    test:assertEquals(<string>result, "Hello");
}

@test:Config {enable: true}
function testHello55LdapAuthWithEmptyScope() returns error? {
    if !isWindowsEnvironment() {
        grpc:CredentialsConfig config = {
            username: "alice",
            password: "alice@123"
        };
        HelloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
        string response = check hClient->hello55EmptyScope("Hello");
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55BasicAuthWithEmptyScope() returns error? {
    grpc:CredentialsConfig config = {
        username: "admin",
        password: "123"
    };

    HelloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string response = check hClient->hello55EmptyScope("Hello");
    test:assertEquals(response, "Hello");
}

@test:Config {enable: true}
function testHello55OAuth2AuthWithEmptyScope() returns error? {
    grpc:OAuth2ClientCredentialsGrantConfig config = {
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

    HelloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string response = check hClient->hello55EmptyScope("Hello");
    test:assertEquals(response, "Hello");
}

@test:Config {enable: true}
function testHello55ServerStreamingOAuth2Auth() returns error? {
    grpc:OAuth2ClientCredentialsGrantConfig config = {
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

    HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    stream<string, error?> response = check hClient->hello55ServerStreaming("Hello");
    var value1 = check response.next();
    var value2 = check response.next();
    test:assertFalse(value1 is ());
    test:assertFalse(value2 is ());
    test:assertEquals((<record {|string value;|}>value1)["value"], "Hello 1");
    test:assertEquals((<record {|string value;|}>value2)["value"], "Hello 2");
}

@test:Config {enable: true}
function testHello55ClientStreamingOAuth2Auth() returns error? {
    grpc:OAuth2ClientCredentialsGrantConfig config = {
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

    HelloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55ClientStreamingStreamingClient sClient = check hClient->hello55ClientStreaming();
    check sClient->sendString("Hello");
    check sClient->sendString("World");
    check sClient->complete();

    string? response = check sClient->receiveString();
    test:assertTrue(response is string);
    test:assertEquals(<string>response, "Hello World");
}

@test:Config {enable: true}
function testHello55EmptyAuthHeader() returns error? {
    HelloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255");
    string|grpc:Error response = hClient->hello55EmptyScope("Hello");
    test:assertTrue(response is grpc:Error);
    test:assertEquals((<grpc:Error>response).message(), "Authorization header does not exist");
}
