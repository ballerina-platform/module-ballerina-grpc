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

import ballerina/io;
import ballerina/oauth2;

listener Listener ep30 = new (9120);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_30,
    descMap: getDescriptorMap30()
}
service /HelloWorld30 on ep30 {

    remote isolated function testStringValueReturn(HelloWorld30StringCaller caller, ContextString request) {
        io:println("name: " + request.content);
        string message = "Hello " + request.content;
        map<string|string[]> responseHeaders = {};
        OAuth2IntrospectionConfig config = {
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
        if (!request.headers.hasKey(AUTH_HEADER)) {
            Error? err = caller->sendError(error AbortedError("AUTH_HEADER header is missing"));
        } else {
            ListenerOAuth2Handler handler = new(config);
            oauth2:IntrospectionResponse|UnauthenticatedError|PermissionDeniedError authResult = handler->authorize(request.headers, "read");
            if (authResult is oauth2:IntrospectionResponse) {
                responseHeaders["x-id"] = ["1234567890", "2233445677"];
                ContextString responseMessage = {content: message, headers: responseHeaders};
                Error? err = caller->sendContextString(responseMessage);
                if (err is Error) {
                    io:println("Error from Connector: " + err.message());
                } else {
                    io:println("Server send response : " + message);
                }
            } else {
                Error? err = caller->sendError(error AbortedError("Unauthorized"));
            }
        }
        checkpanic caller->complete();
    }
}
