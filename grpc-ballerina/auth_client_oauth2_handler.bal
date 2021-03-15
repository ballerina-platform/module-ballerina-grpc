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

import ballerina/oauth2;

# Represents OAuth2 client credentials grant configurations for OAuth2 authentication.
public type OAuth2ClientCredentialsGrantConfig record {|
    *oauth2:ClientCredentialsGrantConfig;
|};

# Represents OAuth2 password grant configurations for OAuth2 authentication.
public type OAuth2PasswordGrantConfig record {|
    *oauth2:PasswordGrantConfig;
|};

# Represents OAuth2 refresh token grant configurations for OAuth2 authentication.
public type OAuth2RefreshTokenGrantConfig record {|
    *oauth2:RefreshTokenGrantConfig;
|};

# Represents OAuth2 grant configurations for OAuth2 authentication.
public type OAuth2GrantConfig OAuth2ClientCredentialsGrantConfig|OAuth2PasswordGrantConfig|OAuth2RefreshTokenGrantConfig;

# Defines the OAuth2 handler for client authentication.
public client class ClientOAuth2Handler {

    oauth2:ClientOAuth2Provider provider;

    # Initializes the `grpc:ClientOAuth2Handler` object.
    #
    # + config - The `grpc:OAuth2GrantConfig` instance
    public isolated function init(OAuth2GrantConfig config) {
        self.provider = new(config);
    }

    # Enrich the headers with the relevant authentication requirements.
    #
    # + headers - The headers map `map<string|string[]>` as an input
    # + return - The updated headers map `map<string|string[]>` instance or else an `grpc:ClientAuthError` in case of an error
    remote isolated function enrich(map<string|string[]> headers) returns map<string|string[]>|ClientAuthError {
        string|oauth2:Error result = self.provider.generateToken();
        if (result is oauth2:Error) {
            return prepareClientAuthError("Failed to enrich request with OAuth2 token.", result);
        }
        string token = AUTH_SCHEME_BEARER + " " + checkpanic result;
        headers[AUTH_HEADER] = [token];
        return headers;
    }
}
