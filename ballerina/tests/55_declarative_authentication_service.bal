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

listener Listener ep55WithScopes = new (9155);
listener Listener ep55EmptyScope = new (9255);

JwtValidatorConfig jwtAuthConfig55 = {
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

OAuth2IntrospectionConfig oauth2IntroConfig55 = {
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

LdapUserStoreConfig ldapUserStoreConfig = {
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

JwtValidatorConfigWithScopes jwtAuthConfig55WithScopes = {
    jwtValidatorConfig: jwtAuthConfig55,
    scopes: "write"
};

JwtValidatorConfigWithScopes jwtAuthConfig55EmptyScope = {
    jwtValidatorConfig: jwtAuthConfig55
};

OAuth2IntrospectionConfigWithScopes oauth2config55WithScopes = {
    oauth2IntrospectionConfig: oauth2IntroConfig55,
    scopes: "write"
};

OAuth2IntrospectionConfigWithScopes oauth2config55EmptyScope = {
    oauth2IntrospectionConfig: oauth2IntroConfig55
};

LdapUserStoreConfigWithScopes ldapUserStoreconfig55WithScopes = {
    ldapUserStoreConfig: ldapUserStoreConfig,
    scopes: "developer"
};

LdapUserStoreConfigWithScopes ldapUserStoreconfig55EmptyScope = {
    ldapUserStoreConfig: ldapUserStoreConfig
};

FileUserStoreConfigWithScopes fileUserStoreConfig55WithScopes = {
    fileUserStoreConfig: {},
    scopes: "write"
};

FileUserStoreConfigWithScopes fileUserStoreConfig55EmptyScope  = {
    fileUserStoreConfig: {}
};

@ServiceConfig {
    auth: [
        jwtAuthConfig55WithScopes,
        oauth2config55WithScopes,
        fileUserStoreConfig55WithScopes
    ]
}
@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_55, descMap: getDescriptorMap55()}
service "helloWorld55" on ep55WithScopes {

    remote function hello55BiDiWithCaller(HelloWorld55StringCaller caller,
     stream<string, Error?> clientStream) returns error? {
        record {|string value;|}|Error? result = clientStream.next();
        result = clientStream.next();
        check caller->sendString("Hello");
        check caller->complete();
    }

    remote function hello55BiDiWithReturn(stream<string, Error?> clientStream) 
    returns stream<string, Error?>|error? {
        return clientStream;
    }

    remote function hello55UnaryWithCaller(HelloWorld55StringCaller caller, string value) returns error? {
        check caller->sendString(value);
        check caller->complete();
    }

    remote function hello55UnaryWithReturn(string value) returns string|error? {
        return value;
    }
}

@ServiceConfig {
    auth: [
        jwtAuthConfig55EmptyScope,
        oauth2config55EmptyScope,
        fileUserStoreConfig55EmptyScope
    ]
}
@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_55, descMap: getDescriptorMap55()}
service "helloWorld55EmptyScope" on ep55EmptyScope {

    remote function hello55EmptyScope(HelloWorld55EmptyScopeStringCaller caller, string value) returns error? {
        check caller->sendString(value);
        check caller->complete();
    }
}
