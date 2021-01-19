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

import ballerina/jwt;

# Represents JWT validator configurations for JWT authentication.
#
# + scopeKey - The key used to fetch the scopes
public type JwtValidatorConfig record {|
    *jwt:ValidatorConfig;
    string scopeKey = "scope";
|};

# Defines the JWT auth handler for listener authentication.
public class ListenerJwtAuthHandler {

    jwt:ListenerJwtAuthProvider provider;
    string scopeKey;

    # Initializes the `grpc:ListenerJwtAuthHandler` object.
    #
    # + config - The `grpc:JwtValidatorConfig` instance
    public isolated function init(JwtValidatorConfig config) {
        self.scopeKey = config.scopeKey;
        self.provider = new(config);
    }

    # Authenticates with the relevant authentication requirements.
    #
    # + headers - The headers map `map<string|string[]>` as an input
    # + return - The `jwt:Payload` instance or else an `UnauthenticatedError` error
    public isolated function authenticate(map<string|string[]> headers) returns jwt:Payload|UnauthenticatedError {
        string|Error credential = extractCredential(headers);
        if (credential is Error) {
            return error UnauthenticatedError(credential.message());
        } else {
            jwt:Payload|jwt:Error details = self.provider.authenticate(credential);
            if (details is jwt:Error) {
                return error UnauthenticatedError(details.message());
            }
            return checkpanic details;
        }
    }

    # Authorizes with the relevant authorization requirements.
    #
    # + jwtPayload - The `jwt:Payload` instance which is received from authentication results
    # + expectedScopes - The expected scopes as `string` or `string[]`
    # + return - `()`, if it is successful or else a `PermissionDeniedError` error
    public isolated function authorize(jwt:Payload jwtPayload, string|string[] expectedScopes) returns PermissionDeniedError? {
        string scopeKey = self.scopeKey;
        var actualScope = jwtPayload[scopeKey];
        if (actualScope is string) {
            boolean matched = matchScopes(actualScope, expectedScopes);
            if (matched) {
                return;
            }
        }
        return error PermissionDeniedError(PERMISSION_DENIED_ERROR_MSG);
    }
}
