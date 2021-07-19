// // Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
// //
// // WSO2 Inc. licenses this file to you under the Apache License,
// // Version 2.0 (the "License"); you may not use this file except
// // in compliance with the License.
// // You may obtain a copy of the License at
// //
// // http://www.apache.org/licenses/LICENSE-2.0
// //
// // Unless required by applicable law or agreed to in writing,
// // software distributed under the License is distributed on an
// // "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// // KIND, either express or implied.  See the License for the
// // specific language governing permissions and limitations
// // under the License.

// import ballerina/test;

// @test:Config {enable: true}
// function testHello55BiDiWithCaller() returns error? {
//     JwtIssuerConfig config = {
//         username: "admin",
//         issuer: "wso2",
//         audience: ["ballerina"],
//         customClaims: { "scope": "write" },
//         signatureConfig: {
//             config: {
//                 keyStore: {
//                     path: KEYSTORE_PATH,
//                     password: "ballerina"
//                 },
//                 keyAlias: "ballerina",
//                 keyPassword: "ballerina"
//             }
//         }
//     };
//     ClientSelfSignedJwtAuthHandler handler = new(config);
//     map<string|string[]> requestHeaders = {};
//     requestHeaders = check handler.enrich(requestHeaders);

//     helloWorld55Client hClient = check new ("http://localhost:9155");
//     Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
//     check strClient->sendContextString({
//         content: "Hello from client",
//         headers: requestHeaders
//     });
//     check strClient->complete();
//     string? s = check strClient->receiveString();
//     if (s is ()) {
//         test:assertFail("Expected a response");
//     } else {
//         test:assertEquals(s, "Hello from service");
//     }
// }

// @test:Config {enable: true}
// function testHello55BiDiWithCallerUnauthenticated() returns error? {
//     map<string|string[]> requestHeaders = {
//         "x-id": "0987654321",
//         "authorization": "bearer "
//     };

//     helloWorld55Client hClient = check new ("http://localhost:9155");
//     Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
//     check strClient->sendContextString({
//         content: "Hello from client",
//         headers: requestHeaders
//     });
//     check strClient->complete();
//     string|Error? s = strClient->receiveString();
//     if s is UnauthenticatedError {
//         test:assertEquals(s.message(), "Failed to authenticate client");
//     } else {
//         test:assertFail("Expected an error");
//     }
// }

// @test:Config {enable: true}
// function testHello55BiDiWithCallerInvalidPermission() returns error? {
//     JwtIssuerConfig config = {
//         username: "admin",
//         issuer: "wso2",
//         audience: ["ballerina"],
//         customClaims: { "scope": "read" },
//         signatureConfig: {
//             config: {
//                 keyStore: {
//                     path: KEYSTORE_PATH,
//                     password: "ballerina"
//                 },
//                 keyAlias: "ballerina",
//                 keyPassword: "ballerina"
//             }
//         }
//     };
//     ClientSelfSignedJwtAuthHandler handler = new(config);
//     map<string|string[]> requestHeaders = {};
//     requestHeaders = check handler.enrich(requestHeaders);

//     helloWorld55Client hClient = check new ("http://localhost:9155");
//     Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
//     check strClient->sendContextString({
//         content: "Hello from client",
//         headers: requestHeaders
//     });
//     check strClient->complete();
//     string|Error? s = strClient->receiveString();
//     if s is PermissionDeniedError {
//         test:assertEquals(s.message(), "Permission denied");
//     } else {
//         test:assertFail("Expected an error");
//     }
// }

// // @test:Config {enable: true}
// // function testHello55BiDiWithReturn() returns error? {
// //     JwtIssuerConfig config = {
// //         username: "admin",
// //         issuer: "wso2",
// //         audience: ["ballerina"],
// //         customClaims: { "scope": "write" },
// //         signatureConfig: {
// //             config: {
// //                 keyStore: {
// //                     path: KEYSTORE_PATH,
// //                     password: "ballerina"
// //                 },
// //                 keyAlias: "ballerina",
// //                 keyPassword: "ballerina"
// //             }
// //         }
// //     };
// //     ClientSelfSignedJwtAuthHandler handler = new(config);
// //     map<string|string[]> requestHeaders = {};
// //     requestHeaders = check handler.enrich(requestHeaders);

// //     helloWorld55Client hClient = check new ("http://localhost:9155");
// //     Hello55BiDiWithReturnStreamingClient strClient = check hClient->hello55BiDiWithReturn();
// //     check strClient->sendContextString({
// //         content: "Hello from client",
// //         headers: requestHeaders
// //     });
// //     check strClient->complete();
// //     string? s = check strClient->receiveString();
// //     if (s is ()) {
// //         test:assertFail("Expected a response");
// //     } else {
// //         test:assertEquals(s, "Hello from client");
// //     }
// // }

// // @test:Config {enable: true}
// // function testHello55BiDiWithReturnUnauthenticated() returns error? {
// //     map<string|string[]> requestHeaders = {
// //         "x-id": "0987654321",
// //         "authorization": "bearer "
// //     };

// //     helloWorld55Client hClient = check new ("http://localhost:9155");
// //     Hello55BiDiWithReturnStreamingClient strClient = check hClient->hello55BiDiWithReturn();
// //     check strClient->sendContextString({
// //         content: "Hello from client",
// //         headers: requestHeaders
// //     });
// //     check strClient->complete();
// //     string|Error? s = strClient->receiveString();
// //     if s is UnauthenticatedError {
// //         test:assertEquals(s.message(), "Failed to authenticate client");
// //     } else {
// //         test:assertFail("Expected an error");
// //     }
// // }

// // @test:Config {enable: true}
// // function testHello55BiDiWithReturnInvalidPermission() returns error? {
// //     JwtIssuerConfig config = {
// //         username: "admin",
// //         issuer: "wso2",
// //         audience: ["ballerina"],
// //         customClaims: { "scope": "read" },
// //         signatureConfig: {
// //             config: {
// //                 keyStore: {
// //                     path: KEYSTORE_PATH,
// //                     password: "ballerina"
// //                 },
// //                 keyAlias: "ballerina",
// //                 keyPassword: "ballerina"
// //             }
// //         }
// //     };
// //     ClientSelfSignedJwtAuthHandler handler = new(config);
// //     map<string|string[]> requestHeaders = {};
// //     requestHeaders = check handler.enrich(requestHeaders);

// //     helloWorld55Client hClient = check new ("http://localhost:9155");
// //     Hello55BiDiWithReturnStreamingClient strClient = check hClient->hello55BiDiWithReturn();
// //     check strClient->sendContextString({
// //         content: "Hello from client",
// //         headers: requestHeaders
// //     });
// //     check strClient->complete();
// //     string|Error? s = strClient->receiveString();
// //     if s is PermissionDeniedError {
// //         test:assertEquals(s.message(), "Permission denied");
// //     } else {
// //         test:assertFail("Expected an error");
// //     }
// // }

// @test:Config {enable: true}
// function testHello55UnaryWithCaller() returns error? {
//     JwtIssuerConfig config = {
//         username: "admin",
//         issuer: "wso2",
//         audience: ["ballerina"],
//         customClaims: { "scope": "write" },
//         signatureConfig: {
//             config: {
//                 keyStore: {
//                     path: KEYSTORE_PATH,
//                     password: "ballerina"
//                 },
//                 keyAlias: "ballerina",
//                 keyPassword: "ballerina"
//             }
//         }
//     };
//     ClientSelfSignedJwtAuthHandler handler = new(config);
//     map<string|string[]> requestHeaders = {};
//     requestHeaders = check handler.enrich(requestHeaders);
//     ContextString ctxString = {
//         headers: requestHeaders,
//         content: "Hello from client"
//     };

//     helloWorld55Client hClient = check new ("http://localhost:9155");
//     string|Error result = hClient->hello55UnaryWithCaller(ctxString);
//     if (result is Error) {
//         test:assertFail(result.message());
//     } else {
//         test:assertEquals(result, "Hello from client");
//     }




//     requestHeaders = {
//         "authorization": "bearer asfasfasf"
//     };
//     ctxString = {
//         headers: requestHeaders,
//         content: "Hello from client"
//     };

//     hClient = check new ("http://localhost:9155");
//     result = hClient->hello55UnaryWithCaller(ctxString);
//     if result is Error {
//         test:assertEquals(result.message(), "Failed to authenticate client");
//     } else {
//         test:assertFail("Expected an error");
//     }



//     config = {
//         username: "admin",
//         issuer: "wso2",
//         audience: ["ballerina"],
//         customClaims: { "scope": "read" },
//         signatureConfig: {
//             config: {
//                 keyStore: {
//                     path: KEYSTORE_PATH,
//                     password: "ballerina"
//                 },
//                 keyAlias: "ballerina",
//                 keyPassword: "ballerina"
//             }
//         }
//     };
//     handler = new(config);
//     requestHeaders = {};
//     requestHeaders = check handler.enrich(requestHeaders);
//     ctxString = {
//         headers: requestHeaders,
//         content: "Hello from client"
//     };

//     hClient = check new ("http://localhost:9155");
//     result = hClient->hello55UnaryWithCaller(ctxString);
//     if result is Error {
//         test:assertEquals(result.message(), "Permission denied");
//     } else {
//         test:assertFail("Expected an error");
//     }

//     config = {
//         username: "admin",
//         issuer: "wso2",
//         audience: ["ballerina"],
//         customClaims: { "scope": "read" },
//         signatureConfig: {
//             config: {
//                 keyStore: {
//                     path: KEYSTORE_PATH,
//                     password: "ballerina"
//                 },
//                 keyAlias: "ballerina",
//                 keyPassword: "ballerina"
//             }
//         }
//     };
//     handler = new(config);
//     requestHeaders = {};
//     requestHeaders = check handler.enrich(requestHeaders);
//     ctxString = {
//         headers: requestHeaders,
//         content: "Hello from client"
//     };

//     hClient = check new ("http://localhost:9155");
//     result = hClient->hello55UnaryWithCaller(ctxString);
//     if result is Error {
//         test:assertEquals(result.message(), "Permission denied");
//     } else {
//         test:assertFail("Expected an error");
//     }
// }

// // @test:Config {enable: true}
// // function testHello55UnaryWithCallerUnauthenticated() returns error? {
// //     map<string|string[]> requestHeaders = {
// //         "authorization": "bearer asfasfasf"
// //     };
// //     ContextString ctxString = {
// //         headers: requestHeaders,
// //         content: "Hello from client"
// //     };

// //     helloWorld55Client hClient = check new ("http://localhost:9155");
// //     string|Error result = hClient->hello55UnaryWithCaller(ctxString);
// //     if result is Error {
// //         test:assertEquals(result.message(), "Failed to authenticate client");
// //     } else {
// //         test:assertFail("Expected an error");
// //     }
// // }

// // @test:Config {enable: true}
// // function testHello55UnaryWithCallerInvalidPermission() returns error? {
// //     JwtIssuerConfig config = {
// //         username: "admin",
// //         issuer: "wso2",
// //         audience: ["ballerina"],
// //         customClaims: { "scope": "read" },
// //         signatureConfig: {
// //             config: {
// //                 keyStore: {
// //                     path: KEYSTORE_PATH,
// //                     password: "ballerina"
// //                 },
// //                 keyAlias: "ballerina",
// //                 keyPassword: "ballerina"
// //             }
// //         }
// //     };
// //     ClientSelfSignedJwtAuthHandler handler = new(config);
// //     map<string|string[]> requestHeaders = {};
// //     requestHeaders = check handler.enrich(requestHeaders);
// //     ContextString ctxString = {
// //         headers: requestHeaders,
// //         content: "Hello from client"
// //     };

// //     helloWorld55Client hClient = check new ("http://localhost:9155");
// //     string|Error result = hClient->hello55UnaryWithCaller(ctxString);
// //     if result is Error {
// //         test:assertEquals(result.message(), "Permission denied");
// //     } else {
// //         test:assertFail("Expected an error");
// //     }
// // }
