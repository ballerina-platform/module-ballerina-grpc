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
import ballerina/jballerina.java;
import ballerina/jwt;
import ballerina/oauth2;

// This function is used for declarative auth design, where the authentication/authorization decision is taken by
// reading the auth annotations provided in service and the `Authorization` header taken with an interop call.
// This function is injected to the first lines of a grpc resource function. Then the logic will be executed during
// the runtime.
// If this function returns `()`, it will be moved to the execution of business logic, else there will be a
// UnauthenticatedError/ PermissionDeniedError sent by the `grpc:Caller` which is taken with an interop call. The
// execution flow will be broken by panic with a distinct error.
# Uses for declarative auth design, where the authentication/authorization decision is taken
# by reading the auth annotations provided in service/resource and the `Authorization` header of request.
# 
# + serviceRef - The service reference where the resource locates
# + methodName - The name of the subjected resource
# + resourcePath - The relative path
public isolated function authenticateResource(Service serviceRef, string methodName, string[] resourcePath) {
    ListenerAuthConfig[]? authConfig = getListenerAuthConfig(serviceRef);
    if authConfig is () {
        return;
    }
    string|Error authHeader = externGetAuthorizationHeader();
    if authHeader is string {
        map<string> headers = {
            "authorization": authHeader
        };
        UnauthenticatedError|PermissionDeniedError? result = tryAuthenticate(<ListenerAuthConfig[]>authConfig, headers);
        if result is UnauthenticatedError || result is PermissionDeniedError {
            sendError(result);
        }
    } else {
        sendError(authHeader);
    }
}

isolated function tryAuthenticate(ListenerAuthConfig[] authConfig, map<string|string[]> headers) returns UnauthenticatedError|PermissionDeniedError? {
    foreach ListenerAuthConfig config in authConfig {
        if config is FileUserStoreConfigWithScopes {
            ListenerFileUserStoreBasicAuthHandler handler = new(config.fileUserStoreConfig);
            auth:UserDetails|UnauthenticatedError authn = handler.authenticate(headers);
            string|string[]? scopes = config?.scopes;
            if authn is auth:UserDetails {
                if scopes is string|string[] {
                    PermissionDeniedError? authz = handler.authorize(authn, scopes);
                    return authz;
                }
                return;
            }
        } else if config is LdapUserStoreConfigWithScopes {
            ListenerLdapUserStoreBasicAuthHandler handler = new(config.ldapUserStoreConfig);
            auth:UserDetails|UnauthenticatedError authn = handler->authenticate(headers);
            string|string[]? scopes = config?.scopes;
            if authn is auth:UserDetails {
                if scopes is string|string[] {
                    PermissionDeniedError? authz = handler->authorize(authn, scopes);
                    return authz;
                }
                return;
            }
        } else if config is JwtValidatorConfigWithScopes {
            ListenerJwtAuthHandler handler = new(config.jwtValidatorConfig);
            jwt:Payload|UnauthenticatedError authn = handler.authenticate(headers);
            string|string[]? scopes = config?.scopes;
            if authn is jwt:Payload {
                if scopes is string|string[] {
                    PermissionDeniedError? authz = handler.authorize(authn, scopes);
                    return authz;
                }
                return;
            }
        } else {
            // Here, config is OAuth2IntrospectionConfigWithScopes
            ListenerOAuth2Handler handler = new(config.oauth2IntrospectionConfig);
            oauth2:IntrospectionResponse|UnauthenticatedError|PermissionDeniedError auth = handler->authorize(headers, config?.scopes);
            if auth is oauth2:IntrospectionResponse {
                return;
            } else if auth is PermissionDeniedError {
                return auth;
            }
        }
    }
    return error UnauthenticatedError("Failed to authenticate client");
}

isolated function getListenerAuthConfig(Service serviceRef)
                                        returns ListenerAuthConfig[]? {
    ListenerAuthConfig[]? serviceAuthConfig = getServiceAuthConfig(serviceRef);
    if serviceAuthConfig is ListenerAuthConfig[] {
        return serviceAuthConfig;
    }
}

isolated function getServiceAuthConfig(Service serviceRef) returns ListenerAuthConfig[]? {
    typedesc<any> serviceTypeDesc = typeof serviceRef;
    var serviceAnnotation = serviceTypeDesc.@AuthConfig;
    if serviceAnnotation is () {
        return;
    }
    AuthServiceConfig serviceConfig = <AuthServiceConfig>serviceAnnotation;
    return serviceConfig?.auth;
}

isolated function sendError(Error authError) {
    panic authError;
}

isolated function externGetAuthorizationHeader() returns string|Error = @java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils"
} external;
