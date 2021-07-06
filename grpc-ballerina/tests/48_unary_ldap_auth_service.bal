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

listener Listener ep48 = new (9148);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_48,
    descMap: getDescriptorMap48()
}
service "HelloWorld48" on ep48 {

    isolated remote function testStringValueReturn(ContextString request) returns string|error {
        LdapUserStoreConfig config = {
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

        if !request.headers.hasKey(AUTH_HEADER) {
            return error AbortedError("AUTH_HEADER header is missing");
        } else {
            ListenerLdapUserStoreBasicAuthHandler handler = new(config);
            auth:UserDetails|UnauthenticatedError authnResult = handler->authenticate(request.headers);
            if (authnResult is UnauthenticatedError) {
                return authnResult;
            } else {
                PermissionDeniedError? authzResult = handler->authorize(<auth:UserDetails>authnResult, "developer");
                if (authzResult is ()) {
                    return "Hello WSO2";
                } else {
                    return authzResult;
                }
            }
        }
    }
}
