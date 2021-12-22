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
import ballerina/jwt;
import ballerina/oauth2;

# Represents the Authorization header name.
public const string AUTH_HEADER = "authorization";

# The prefix used to denote the Basic authentication scheme.
public const string AUTH_SCHEME_BASIC = "Basic";

# The prefix used to denote the Bearer authentication scheme.
public const string AUTH_SCHEME_BEARER = "Bearer";

# The permission denied error message.
public const string PERMISSION_DENIED_ERROR_MSG = "Permission denied";

# The permission denied error message.
public const string UNAUTHENTICATED_ERROR_MSG = "Unauthenticated";

# Represents credentials for Basic Auth authentication.
public type CredentialsConfig record {|
    *auth:CredentialsConfig;
|};

# Represents token for Bearer token authentication.
#
# + token - Bearer token for authentication
public type BearerTokenConfig record {|
    string token;
|};

# Represents JWT issuer configurations for JWT authentication.
public type JwtIssuerConfig record {|
    *jwt:IssuerConfig;
|};

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

# Represents OAuth2 JWT bearer grant configurations for OAuth2 authentication.
public type OAuth2JwtBearerGrantConfig record {|
    *oauth2:JwtBearerGrantConfig;
|};

# Represents OAuth2 grant configurations for OAuth2 authentication.
public type OAuth2GrantConfig OAuth2ClientCredentialsGrantConfig|OAuth2PasswordGrantConfig|OAuth2RefreshTokenGrantConfig|OAuth2JwtBearerGrantConfig;

# Represents file user store configurations for Basic Auth authentication.
public type FileUserStoreConfig record {|
    *auth:FileUserStoreConfig;
|};

# Represents LDAP user store configurations for Basic Auth authentication.
public type LdapUserStoreConfig record {|
    *auth:LdapUserStoreConfig;
|};

# Represents JWT validator configurations for JWT authentication.
#
# + scopeKey - The key used to fetch the scopes
public type JwtValidatorConfig record {|
    *jwt:ValidatorConfig;
    string scopeKey = "scope";
|};

# Represents OAuth2 introspection server configurations for OAuth2 authentication.
#
# + scopeKey - The key used to fetch the scopes
public type OAuth2IntrospectionConfig record {|
    *oauth2:IntrospectionConfig;
    string scopeKey = "scope";
|};

# Defines the authentication configurations for the HTTP client.
public type ClientAuthConfig CredentialsConfig|BearerTokenConfig|JwtIssuerConfig|OAuth2GrantConfig;

// Defines the client authentication handlers.
type ClientAuthHandler ClientBasicAuthHandler|ClientBearerTokenAuthHandler|ClientSelfSignedJwtAuthHandler|ClientOAuth2Handler;

# Represents the auth annotation for file user store configurations with scopes.
#
# + fileUserStoreConfig - File user store configurations for Basic Auth authentication
# + scopes - Scopes allowed for authorization
public type FileUserStoreConfigWithScopes record {|
    FileUserStoreConfig fileUserStoreConfig;
    string|string[] scopes?;
|};

# Represents the auth annotation for LDAP user store configurations with scopes.
#
# + ldapUserStoreConfig - LDAP user store configurations for Basic Auth authentication
# + scopes - Scopes allowed for authorization
public type LdapUserStoreConfigWithScopes record {|
    LdapUserStoreConfig ldapUserStoreConfig;
    string|string[] scopes?;
|};

# Represents the auth annotation for JWT validator configurations with scopes.
#
# + jwtValidatorConfig - JWT validator configurations for JWT authentication
# + scopes - Scopes allowed for authorization
public type JwtValidatorConfigWithScopes record {|
    JwtValidatorConfig jwtValidatorConfig;
    string|string[] scopes?;
|};

# Represents the auth annotation for OAuth2 introspection server configurations with scopes.
#
# + oauth2IntrospectionConfig - OAuth2 introspection server configurations for OAuth2 authentication
# + scopes - Scopes allowed for authorization
public type OAuth2IntrospectionConfigWithScopes record {|
    OAuth2IntrospectionConfig oauth2IntrospectionConfig;
    string|string[] scopes?;
|};

# Defines the authentication configurations for the gRPC listener.
public type ListenerAuthConfig FileUserStoreConfigWithScopes|
                                LdapUserStoreConfigWithScopes|
                                JwtValidatorConfigWithScopes|
                                OAuth2IntrospectionConfigWithScopes;

// Defines the listener authentication handlers.
type ListenerAuthHandler ListenerFileUserStoreBasicAuthHandler|ListenerLdapUserStoreBasicAuthHandler|
                        ListenerJwtAuthHandler|ListenerOAuth2Handler;
