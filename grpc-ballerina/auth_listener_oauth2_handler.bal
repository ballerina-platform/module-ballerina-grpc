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

# Defines the OAuth2 handler for listener authentication.
public isolated client class ListenerOAuth2Handler {

    private final oauth2:ListenerOAuth2Provider provider;
    private final string & readonly scopeKey;

    # Initializes the OAuth2 handler for the listener authentication.
    #
    # + config - OAuth2 introspection server configurations
    public isolated function init(OAuth2IntrospectionConfig config) {
        self.scopeKey = config.scopeKey.cloneReadOnly();
        self.provider = new (config);
    }

    # Authorizes with the relevant authentication & authorization requirements.
    #
    # + headers - The headers map `map<string|string[]>` as an input
    # + expectedScopes - The expected scopes as `string` or `string[]`
    # + optionalParams - Map of optionalParams parameters that need to be sent to introspection endpoint
    # + return - The `oauth2:IntrospectionResponse` instance or else `UnauthenticatedError` or `PermissionDeniedError` type error
    remote isolated function authorize(map<string|string[]> headers, string|string[]? expectedScopes = (), 
                                        map<string>? optionalParams = ()) 
                                        returns oauth2:IntrospectionResponse|UnauthenticatedError|PermissionDeniedError {
        string|Error credential = extractCredential(headers);
        if (credential is Error) {
            return error UnauthenticatedError(credential.message());
        } else {
            oauth2:IntrospectionResponse|oauth2:Error details = self.provider.authorize(<string>credential);
            if details is oauth2:IntrospectionResponse {
                if (!details.active) {
                    return error UnauthenticatedError(UNAUTHENTICATED_ERROR_MSG);
                }
                if (expectedScopes is ()) {
                    return details;
                }

                string scopeKey = self.scopeKey;
                var actualScope = details[scopeKey];
                if (actualScope is string) {
                    boolean matched = matchScopes(convertToArray(actualScope), <string|string[]>expectedScopes);
                    if (matched) {
                        return details;
                    }
                }
                return error PermissionDeniedError(PERMISSION_DENIED_ERROR_MSG);
            } else {
                return error UnauthenticatedError(UNAUTHENTICATED_ERROR_MSG);
            }
        }
    }
}
