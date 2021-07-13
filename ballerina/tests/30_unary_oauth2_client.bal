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

@test:Config {enable:true}
public isolated function testStringValueReturnWithOauth2() returns Error? {
    HelloWorld30Client helloWorldEp = check new ("http://localhost:9120");
    map<string|string[]> requestHeaders = {};

    OAuth2ClientCredentialsGrantConfig config = {
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
    ClientOAuth2Handler handler = new(config);
    map<string|string[]>|ClientAuthError result = handler->enrich(requestHeaders);
    if (result is ClientAuthError) {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturn(requestMessage);
    if (unionResp is Error) {
        test:assertFail(msg = unionResp.message());
    } else {
        test:assertEquals(unionResp, "Hello WSO2");
    }
}
