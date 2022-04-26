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

import ballerina/grpc;

listener grpc:Listener ep55WithScopes = new (9155);
listener grpc:Listener ep55EmptyScope = new (9255);

grpc:JwtValidatorConfig jwtAuthConfig55 = {
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
};

grpc:OAuth2IntrospectionConfig oauth2IntroConfig55 = {
    url: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token/introspect",
    tokenTypeHint: "access_token",
    scopeKey: "scp",
    clientConfig: {
        secureSocket: {
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            }
        }
    }
};

grpc:LdapUserStoreConfig ldapUserStoreConfig = {
    domainName: "avix.lk",
    connectionUrl: "ldap://localhost:389",
    connectionName: "cn=admin,dc=avix,dc=lk",
    connectionPassword: "avix123",
    userSearchBase: "ou=Users,dc=avix,dc=lk",
    userEntryObjectClass: "inetOrgPerson",
    userNameAttribute: "uid",
    userNameSearchFilter: "(&(objectClass=inetOrgPerson)(uid=?))",
    userNameListFilter: "(objectClass=inetOrgPerson)",
    groupSearchBase: ["ou=Groups,dc=avix,dc=lk"],
    groupEntryObjectClass: "groupOfNames",
    groupNameAttribute: "cn",
    groupNameSearchFilter: "(&(objectClass=groupOfNames)(cn=?))",
    groupNameListFilter: "(objectClass=groupOfNames)",
    membershipAttribute: "member",
    userRolesCacheEnabled: true,
    connectionPoolingEnabled: false,
    connectionTimeout: 5,
    readTimeout: 60
};

grpc:JwtValidatorConfigWithScopes jwtAuthConfig55WithScopes = {
    jwtValidatorConfig: jwtAuthConfig55,
    scopes: "write"
};

grpc:JwtValidatorConfigWithScopes jwtAuthConfig55EmptyScope = {
    jwtValidatorConfig: jwtAuthConfig55
};

grpc:OAuth2IntrospectionConfigWithScopes oauth2config55WithScopes = {
    oauth2IntrospectionConfig: oauth2IntroConfig55,
    scopes: "write"
};

grpc:OAuth2IntrospectionConfigWithScopes oauth2config55EmptyScope = {
    oauth2IntrospectionConfig: oauth2IntroConfig55
};

grpc:LdapUserStoreConfigWithScopes ldapUserStoreconfig55WithScopes = {
    ldapUserStoreConfig: ldapUserStoreConfig,
    scopes: "developer"
};

grpc:LdapUserStoreConfigWithScopes ldapUserStoreconfig55EmptyScope = {
    ldapUserStoreConfig: ldapUserStoreConfig
};

grpc:FileUserStoreConfigWithScopes fileUserStoreConfig55WithScopes = {
    fileUserStoreConfig: {},
    scopes: "write"
};

grpc:FileUserStoreConfigWithScopes fileUserStoreConfig55EmptyScope = {
    fileUserStoreConfig: {}
};

@grpc:ServiceConfig {
    auth: [
        jwtAuthConfig55WithScopes,
        oauth2config55WithScopes,
        fileUserStoreConfig55WithScopes,
        ldapUserStoreconfig55WithScopes
    ]
}
@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_55_DECLARATIVE_AUTHENTICATION, descMap: getDescriptorMap55DeclarativeAuthentication()}
service "HelloWorld55" on ep55WithScopes {

    remote function hello55BiDiWithCaller(HelloWorld55StringCaller caller,
    stream<string, error?> clientStream) returns error? {
        _ = check clientStream.next();
        _ = check clientStream.next();
        checkpanic caller->sendString("Hello");
        checkpanic caller->complete();
    }

    remote function hello55BiDiWithReturn(stream<string, error?> clientStream)
    returns stream<string, error?>|error? {
        return clientStream;
    }

    remote function hello55UnaryWithCaller(HelloWorld55StringCaller caller, string value) {
        checkpanic caller->sendString(value);
        checkpanic caller->complete();
    }

    remote function hello55UnaryWithReturn(string value) returns string|error? {
        return value;
    }

    remote function hello55ServerStreaming(HelloWorld55StringCaller caller, string value) {
        checkpanic caller->sendString(value + " 1");
        checkpanic caller->sendString(value + " 2");
        checkpanic caller->complete();
    }

    remote function hello55ClientStreaming(HelloWorld55StringCaller caller, stream<string, error?> clientStream) {
        var value1 = clientStream.next();
        var value2 = clientStream.next();
        if value1 is error || value1 is () || value2 is error || value2 is () {
            checkpanic caller->sendError(error grpc:Error("Invalid request"));
        } else {
            checkpanic caller->sendString(value1["value"] + " " + value2["value"]);
        }
        checkpanic caller->complete();
    }
}

@grpc:ServiceConfig {
    auth: [
        jwtAuthConfig55EmptyScope,
        oauth2config55EmptyScope,
        fileUserStoreConfig55EmptyScope,
        ldapUserStoreconfig55EmptyScope
    ]
}
@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_55_DECLARATIVE_AUTHENTICATION, descMap: getDescriptorMap55DeclarativeAuthentication()}
service "HelloWorld55EmptyScope" on ep55EmptyScope {

    remote function hello55EmptyScope(HelloWorld55EmptyScopeStringCaller caller, string value) {
        checkpanic caller->sendString(value);
        checkpanic caller->complete();
    }
}
