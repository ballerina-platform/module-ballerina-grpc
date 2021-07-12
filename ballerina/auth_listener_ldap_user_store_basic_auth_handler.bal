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

import ballerina/auth;

# Defines the LDAP store Basic Auth handler for listener authentication.
public isolated client class ListenerLdapUserStoreBasicAuthHandler {

    private final auth:ListenerLdapUserStoreBasicAuthProvider provider;

    # Initializes the LDAP user store Basic Auth handler for listener authentication.
    #
    # + config - LDAP user store configurations
    public isolated function init(LdapUserStoreConfig config) {
        self.provider = new (config);
    }

    # Authenticates with the relevant authentication requirements.
    #
    # + headers - The headers map `map<string|string[]>` as an input
    # + return - The `auth:UserDetails` instance or else an `UnauthenticatedError` error
    remote isolated function authenticate(map<string|string[]> headers) returns auth:UserDetails|UnauthenticatedError {
        string|Error credential = extractCredential(headers);
        if (credential is Error) {
            return error UnauthenticatedError(credential.message());
        } else {
            auth:UserDetails|auth:Error details = self.provider.authenticate(credential);
            if (details is auth:UserDetails) {
                return details;
            } else {
                return error UnauthenticatedError(details.message());
            }
        }
    }

    # Authorizes with the relevant authorization requirements.
    #
    # + userDetails - The `auth:UserDetails` instance which is received from authentication results
    # + expectedScopes - The expected scopes as `string` or `string[]`
    # + return - `()`, if it is successful or else a `PermissionDeniedError` error
    remote isolated function authorize(auth:UserDetails userDetails, string|string[] expectedScopes) returns PermissionDeniedError? {
        string[]? actualScopes = userDetails?.scopes;
        if (actualScopes is string[]) {
            boolean matched = matchScopes(actualScopes, expectedScopes);
            if (matched) {
                return;
            }
        }
        return error PermissionDeniedError(PERMISSION_DENIED_ERROR_MSG);
    }
}
