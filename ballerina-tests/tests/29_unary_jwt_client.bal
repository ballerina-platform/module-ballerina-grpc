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

@test:Config {enable:true}
isolated function testStringValueReturnWithJwt1() returns grpc:Error? {
    HelloWorld29Client helloWorldEp = check new ("http://localhost:9119");
    map<string|string[]> requestHeaders = {};

    grpc:JwtIssuerConfig config = {
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
    grpc:ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
    if result is grpc:ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturn(requestMessage);
    if unionResp is grpc:Error {
        test:assertFail(msg = unionResp.message());
    } else {
        test:assertEquals(unionResp, "Hello WSO2");
    }
}

@test:Config {enable:true}
isolated function testStringValueReturnWithJwt2() returns grpc:Error? {
    HelloWorld29Client helloWorldEp = check new ("http://localhost:9119");
    map<string|string[]> requestHeaders = {};

    grpc:JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "write update" },
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
    grpc:ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
    if result is grpc:ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturn(requestMessage);
    if unionResp is grpc:Error {
        test:assertFail(msg = unionResp.message());
    } else {
        test:assertEquals(unionResp, "Hello WSO2");
    }
}

@test:Config {enable:true}
isolated function testStringValueReturnWithJwt3() returns grpc:Error? {
    HelloWorld29Client helloWorldEp = check new ("http://localhost:9119");
    map<string|string[]> requestHeaders = {};

    grpc:JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": ["write", "update"] },
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
    grpc:ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
    if result is grpc:ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturn(requestMessage);
    if unionResp is grpc:Error {
        test:assertFail(msg = unionResp.message());
    } else {
        test:assertEquals(unionResp, "Hello WSO2");
    }
}

@test:Config {enable:true}
isolated function testStringValueReturnWithUnauthorizedJwt1() returns grpc:Error? {
    HelloWorld29Client helloWorldEp = check new ("http://localhost:9119");
    map<string|string[]> requestHeaders = {};

    grpc:JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "delete" },
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
    grpc:ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
    if result is grpc:ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturnNegative(requestMessage);
    if unionResp is grpc:Error {
        test:assertEquals(unionResp.message(), "Permission denied");
    } else {
        test:assertFail(msg = "Expected an error.");
    }
}

@test:Config {enable:true}
isolated function testStringValueReturnWithUnauthorizedJwt2() returns grpc:Error? {
    HelloWorld29Client helloWorldEp = check new ("http://localhost:9119");
    map<string|string[]> requestHeaders = {};

    grpc:JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "read delete" },
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
    grpc:ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
    if result is grpc:ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturnNegative(requestMessage);
    if unionResp is grpc:Error {
        test:assertEquals(unionResp.message(), "Permission denied");
    } else {
        test:assertFail(msg = "Expected an error.");
    }
}

@test:Config {enable:true}
isolated function testStringValueReturnWithUnauthorizedJwt3() returns grpc:Error? {
    HelloWorld29Client helloWorldEp = check new ("http://localhost:9119");
    map<string|string[]> requestHeaders = {};

    grpc:JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": ["read", "delete"] },
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
    grpc:ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
    if result is grpc:ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturnNegative(requestMessage);
    if unionResp is grpc:Error {
        test:assertEquals(unionResp.message(), "Permission denied");
    } else {
        test:assertFail(msg = "Expected an error.");
    }
}

@test:Config {enable:true}
isolated function testStringValueReturnWithInvalidHeaderJwt() returns grpc:Error? {
    HelloWorld29Client helloWorldEp = check new ("http://localhost:9119");
    map<string|string[]> requestHeaders = {
        "x-id": "0987654321",
        "authorization": "bearer invalid"
    };

    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturnNegative(requestMessage);
    if unionResp is grpc:Error {
        test:assertEquals(unionResp.message(), "Credential format does not match to JWT format.");
    } else {
        test:assertFail(msg = "Expected an error.");
    }
}

@test:Config {enable:true}
isolated function testStringValueReturnWithEmptyHeaderJwt() returns grpc:Error? {
    HelloWorld29Client helloWorldEp = check new ("http://localhost:9119");
    map<string|string[]> requestHeaders = {
        "x-id": "0987654321",
        "authorization": "bearer "
    };

    wrappers:ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturnNegative(requestMessage);
    if unionResp is grpc:Error {
        test:assertEquals(unionResp.message(), "Empty authentication header.");
    } else {
        test:assertFail(msg = "Expected an error.");
    }
}
