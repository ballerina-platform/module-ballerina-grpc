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

# Represents JWT issuer configurations for JWT authentication.
public type JwtIssuerConfig record {|
    *jwt:IssuerConfig;
|};

# Defines the self signed JWT handler for client authentication.
public class ClientSelfSignedJwtAuthHandler {

    jwt:ClientSelfSignedJwtAuthProvider provider;

    # Initializes the `grpc:ClientSelfSignedJwtAuthProvider` object.
    #
    # + config - The `grpc:JwtIssuerConfig` instance
    public isolated function init(JwtIssuerConfig config) {
        self.provider = new(config);
    }

    # Enrich the headers with the relevant authentication requirements.
    #
    # + headers - The headers map `map<string|string[]>` as an input
    # + return - The updated headers map `map<string|string[]>` instance or else an `grpc:ClientAuthError` in case of an error
    public isolated function enrich(map<string|string[]> headers) returns map<string|string[]>|ClientAuthError {
        string|jwt:Error result = self.provider.generateToken();
        if (result is jwt:Error) {
            return prepareClientAuthError("Failed to enrich request with JWT.", result);
        }
        string token = AUTH_SCHEME_BEARER + " " + checkpanic result;
        headers[AUTH_HEADER] = [token];
        return headers;
    }
}
