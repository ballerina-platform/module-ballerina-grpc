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

# Represents token for Bearer token authentication.
#
# + token - Bearer token for authentication
public type BearerTokenConfig record {|
    string token;
|};

# Defines the Bearer token auth handler for client authentication.
public class ClientBearerTokenAuthHandler {

    BearerTokenConfig config;

    # Initializes the `grpc:ClientBearerTokenAuthHandler` object.
    #
    # + config - The `grpc:BearerTokenConfig` instance
    public isolated function init(BearerTokenConfig config) {
        self.config = config;
    }

    # Enrich the headers with the relevant authentication requirements.
    #
    # + headers - The headers map `map<string|string[]>` as an input
    # + return - The Bearer tokes as a `string` or else an `grpc:ClientAuthError` in case of an error
    public isolated function enrich(map<string|string[]> headers) returns map<string|string[]>|ClientAuthError {
        string token = AUTH_SCHEME_BEARER + " " + self.config.token;
        headers[AUTH_HEADER] = [token];
        return headers;
    }
}
