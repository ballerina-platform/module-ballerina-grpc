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
import ballerina/protobuf.types.wrappers;
import ballerina/oauth2;

listener grpc:Listener ep30 = new (9120);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_30_UNARY_OAUTH2,
    descMap: getDescriptorMap30UnaryOauth2()
}
service "HelloWorld30" on ep30 {

    remote isolated function testStringValueReturn(HelloWorld30StringCaller caller, ContextString request) {
        string message = "Hello " + request.content;
        map<string|string[]> responseHeaders = {};
        grpc:OAuth2IntrospectionConfig config = {
            url: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token/introspect",
            tokenTypeHint: "access_token",
            scopeKey: "scp",
            clientConfig: {
                secureSocket: {
                    cert: {
                        path: TRUSTSTORE_PATH,
                        password: "ballerina"
                    }
                }
            }
        };
        if !request.headers.hasKey(grpc:AUTH_HEADER) {
            checkpanic caller->sendError(error grpc:AbortedError("AUTH_HEADER header is missing"));
        } else {
            grpc:ListenerOAuth2Handler handler = new (config);
            oauth2:IntrospectionResponse|grpc:UnauthenticatedError|grpc:PermissionDeniedError authResult = handler->authorize(request.headers, "read");
            if authResult is oauth2:IntrospectionResponse {
                responseHeaders["x-id"] = ["1234567890", "2233445677"];
                wrappers:ContextString responseMessage = {content: message, headers: responseHeaders};
                checkpanic caller->sendContextString(responseMessage);
            } else {
                checkpanic caller->sendError(error grpc:AbortedError("Unauthorized"));
            }
        }
        checkpanic caller->complete();
    }

    remote isolated function testStringValueNegative(HelloWorld30StringCaller caller, ContextString request) {
        grpc:OAuth2IntrospectionConfig config = {
            url: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token/introspect",
            tokenTypeHint: "access_token",
            scopeKey: request.content,
            clientConfig: {
                secureSocket: {
                    cert: {
                        path: TRUSTSTORE_PATH,
                        password: "ballerina"
                    }
                }
            }
        };
        grpc:ListenerOAuth2Handler handler = new (config);
        oauth2:IntrospectionResponse|grpc:UnauthenticatedError|grpc:PermissionDeniedError authResult = handler->authorize(request.headers, "read");
        if authResult is grpc:UnauthenticatedError|grpc:PermissionDeniedError {
            checkpanic caller->sendError(authResult);
        } else {
            checkpanic caller->sendError(error grpc:AbortedError("Expected error was not found."));
        }
    }

    remote isolated function testStringValueNoScope(HelloWorld30StringCaller caller, ContextString request) {
        string message = "Hello " + request.content;
        map<string|string[]> responseHeaders = {};
        grpc:OAuth2IntrospectionConfig config = {
            url: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token/introspect",
            tokenTypeHint: "access_token",
            scopeKey: "scp",
            clientConfig: {
                secureSocket: {
                    cert: {
                        path: TRUSTSTORE_PATH,
                        password: "ballerina"
                    }
                }
            }
        };
        if !request.headers.hasKey(grpc:AUTH_HEADER) {
            checkpanic caller->sendError(error grpc:AbortedError("AUTH_HEADER header is missing"));
        } else {
            grpc:ListenerOAuth2Handler handler = new (config);
            oauth2:IntrospectionResponse|grpc:UnauthenticatedError|grpc:PermissionDeniedError authResult = handler->authorize(request.headers, ());
            if authResult is oauth2:IntrospectionResponse {
                responseHeaders["x-id"] = ["1234567890", "2233445677"];
                wrappers:ContextString responseMessage = {content: message, headers: responseHeaders};
                checkpanic caller->sendContextString(responseMessage);
            } else {
                checkpanic caller->sendError(error grpc:AbortedError("Unauthorized"));
            }
        }
        checkpanic caller->complete();
    }
}
