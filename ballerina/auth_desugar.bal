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
// This function is injected into the first lines of a gRPC resource function. Then the logic will be executed during
// the runtime.
// If this function returns `()`, it will be moved to the execution of business logic, else there will be a
// UnauthenticatedError/PermissionDeniedError sent by the `grpc:Caller` which is taken with an interop call. The
// execution flow will be broken by panic with a distinct error.
# Uses for declarative auth design, where the authentication/authorization decision is taken
# by reading the auth annotations provided in service/resource and the `Authorization` header of request.
#
# + serviceRef - The service reference where the resource locates
public isolated function authenticateResource(Service serviceRef) {
    ListenerAuthConfig[]? authConfig = getServiceAuthConfig(serviceRef);
    if authConfig is () {
        return;
    }
    string|Error authHeader = externGetAuthorizationHeader();
    if authHeader is string {
        map<string> headers = {
            authorization: authHeader
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
    boolean authResult = false;
    foreach ListenerAuthConfig config in authConfig {
        if config is FileUserStoreConfigWithScopes {
            authResult = check authenticateWithFileUserStore(config, headers);
        } else if config is LdapUserStoreConfigWithScopes {
            authResult = check authenticateWithLdapUserStore(config, headers);
        } else if config is JwtValidatorConfigWithScopes {
            authResult = check authenticateWithJwtValidator(config, headers);
        } else {
            authResult = check authenticateWithOAuth2IntrospectionConfig(config, headers);
        }
        if authResult {
            return;
        }
    }
    return error UnauthenticatedError("Failed to authenticate client");
}

isolated map<ListenerAuthHandler> authHandlers = {};

isolated function authenticateWithFileUserStore(FileUserStoreConfigWithScopes config, map<string|string[]> headers)
returns PermissionDeniedError|boolean {
    ListenerFileUserStoreBasicAuthHandler handler;
    lock {
        string key = config.fileUserStoreConfig.toString();
        if authHandlers.hasKey(key) {
            handler = <ListenerFileUserStoreBasicAuthHandler>authHandlers.get(key);
        } else {
            handler = new (config.fileUserStoreConfig.cloneReadOnly());
            authHandlers[key] = handler;
        }
    }
    auth:UserDetails|UnauthenticatedError authn = handler.authenticate(headers);
    string|string[]? scopes = config?.scopes;
    if authn is auth:UserDetails {
        if scopes is string|string[] {
            PermissionDeniedError? authz = handler.authorize(authn, scopes);
            if authz is PermissionDeniedError {
                return authz;
            }
        }
        return true;
    }
    return false;
}

isolated function authenticateWithLdapUserStore(LdapUserStoreConfigWithScopes config, map<string|string[]> headers)
returns PermissionDeniedError|boolean {
    ListenerLdapUserStoreBasicAuthHandler handler;
    lock {
        string key = config.ldapUserStoreConfig.toString();
        if authHandlers.hasKey(key) {
            handler = <ListenerLdapUserStoreBasicAuthHandler>authHandlers.get(key);
        } else {
            handler = new (config.ldapUserStoreConfig.cloneReadOnly());
            authHandlers[key] = handler;
        }
    }
    auth:UserDetails|UnauthenticatedError authn = handler->authenticate(headers);
    string|string[]? scopes = config?.scopes;
    if authn is auth:UserDetails {
        if scopes is string|string[] {
            PermissionDeniedError? authz = handler->authorize(authn, scopes);
            if authz is PermissionDeniedError {
                return authz;
            }
        }
        return true;
    }
    return false;
}

isolated function authenticateWithJwtValidator(JwtValidatorConfigWithScopes config, map<string|string[]> headers)
returns PermissionDeniedError|boolean {
    ListenerJwtAuthHandler handler;
    lock {
        string key = config.jwtValidatorConfig.toString();
        if authHandlers.hasKey(key) {
            handler = <ListenerJwtAuthHandler>authHandlers.get(key);
        } else {
            handler = new (config.jwtValidatorConfig.cloneReadOnly());
            authHandlers[key] = handler;
        }
    }
    jwt:Payload|UnauthenticatedError authn = handler.authenticate(headers);
    string|string[]? scopes = config?.scopes;
    if authn is jwt:Payload {
        if scopes is string|string[] {
            PermissionDeniedError? authz = handler.authorize(authn, scopes);
            if authz is PermissionDeniedError {
                return authz;
            }
        }
        return true;
    }
    return false;
}

isolated function authenticateWithOAuth2IntrospectionConfig(OAuth2IntrospectionConfigWithScopes config, map<string|string[]> headers)
returns PermissionDeniedError|boolean {
    // Here, config is OAuth2IntrospectionConfigWithScopes
    ListenerOAuth2Handler handler;
    lock {
        string key = config.oauth2IntrospectionConfig.toString();
        if authHandlers.hasKey(key) {
            handler = <ListenerOAuth2Handler>authHandlers.get(key);
        } else {
            handler = new (config.oauth2IntrospectionConfig.cloneReadOnly());
            authHandlers[key] = handler;
        }
    }
    oauth2:IntrospectionResponse|UnauthenticatedError|PermissionDeniedError auth = handler->authorize(headers, config?.scopes);
    if auth is oauth2:IntrospectionResponse {
        return true;
    } else if auth is PermissionDeniedError {
        return auth;
    }
    return false;
}

isolated function getServiceAuthConfig(Service serviceRef) returns ListenerAuthConfig[]? {
    typedesc<any> serviceTypeDesc = typeof serviceRef;
    var serviceAnnotation = serviceTypeDesc.@ServiceConfig;
    if serviceAnnotation is () {
        return;
    }
    GrpcServiceConfig serviceConfig = <GrpcServiceConfig>serviceAnnotation;
    return serviceConfig?.auth;
}

isolated function sendError(Error authError) {
    panic authError;
}

isolated function externGetAuthorizationHeader() returns string|Error = @java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils"
} external;
