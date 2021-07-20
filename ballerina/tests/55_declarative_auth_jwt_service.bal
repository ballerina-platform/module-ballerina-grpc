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

listener Listener ep55 = new (9155);

JwtValidatorConfigWithScopes jwtAuthConfig55 = {
    jwtValidatorConfig: {
        issuer: "wso2",
        audience: "ballerina",
        signatureConfig: {
            trustStoreConfig: {
                trustStore: {
                    path: TRUSTSTORE_PATH,
                    password: "ballerina"
                },
                certAlias: "ballerina"
            }
        },
        scopeKey: "scope"
    },
    scopes: "write"
};

@AuthConfig {auth: [jwtAuthConfig55]}
@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_55, descMap: getDescriptorMap55()}
service "helloWorld55" on ep55 {

    remote function hello55BiDiWithCaller(HelloWorld55StringCaller caller,
     stream<string, Error?> clientStream) returns error? {
        authenticateResource(self, "", []); // Currently the desugar function is called manually until the compiler supports it
        record {|string value;|}|Error? result = clientStream.next();
        result = clientStream.next();
        check caller->sendString("Hello from service");
        check caller->complete();
    }

    remote function hello55BiDiWithReturn(stream<string, Error?> clientStream) 
    returns stream<string, Error?>|error? {
        authenticateResource(self, "", []); // Currently the desugar function is called manually until the compiler supports it
        return clientStream;
    }

    remote function hello55UnaryWithCaller(HelloWorld55StringCaller caller, string value) returns error? {
        authenticateResource(self, "", []); // Currently the desugar function is called manually until the compiler supports it
        check caller->sendString(value);
        check caller->complete();
    }

    remote function hello55UnaryWithReturn(string value) returns string|error? {
        authenticateResource(self, "", []); // Currently the desugar function is called manually until the compiler supports it
        return value;
    }
}
