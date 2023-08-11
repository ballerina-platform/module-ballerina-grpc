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

import ballerina/test;
import ballerina/time;
import ballerina/jballerina.java;
import ballerina/http;
import ballerina/lang.runtime;

const int oauth2AuthorizationServerPort = 9401;
const string ACCESS_TOKEN = "2YotnFZFEjr1zCsicMWpAA";

@test:Config {enable: true}
isolated function testCheckErrorForRetry() {
    ErrorType[] errorTypes = [
        CancelledError,
        UnKnownError,
        InvalidArgumentError,
        DeadlineExceededError,
        NotFoundError,
        AlreadyExistsError,
        PermissionDeniedError,
        UnauthenticatedError,
        ResourceExhaustedError,
        FailedPreconditionError,
        AbortedError,
        OutOfRangeError,
        UnimplementedError,
        InternalError,
        DataLossError,
        UnavailableError,
        ResiliencyError,
        AllRetryAttemptsFailed

    ];
    ErrorType[] negativeErrorTypes = [
        CancelledError
    ];

    CancelledError cancelledError = error CancelledError("Mocking CancelledError");
    UnKnownError unKnownError = error UnKnownError("Mocking UnKnownError");
    InvalidArgumentError invalidArgumentError = error InvalidArgumentError("Mocking InvalidArgumentError");
    DeadlineExceededError deadlineExceededError = error DeadlineExceededError("Mocking DeadlineExceededError");
    NotFoundError notFoundError = error NotFoundError("Mocking NotFoundError");
    AlreadyExistsError alreadyExistsError = error AlreadyExistsError("Mocking AlreadyExistsError");
    PermissionDeniedError permissionDeniedError = error PermissionDeniedError("Mocking PermissionDeniedError");
    UnauthenticatedError unauthenticatedError = error UnauthenticatedError("Mocking UnauthenticatedError");
    ResourceExhaustedError resourceExhaustedError = error ResourceExhaustedError("Mocking ResourceExhaustedError");
    FailedPreconditionError failedPreconditionError = error FailedPreconditionError("Mocking FailedPreconditionError");
    AbortedError abortedError = error AbortedError("Mocking AbortedError");
    OutOfRangeError outOfRangeError = error OutOfRangeError("Mocking OutOfRangeError");
    UnimplementedError unimplementedError = error UnimplementedError("Mocking UnimplementedError");
    InternalError internalError = error InternalError("Mocking InternalError");
    DataLossError dataLossError = error DataLossError("Mocking DataLossError");
    UnavailableError unavailableError = error UnavailableError("Mocking UnavailableError");
    ResiliencyError resiliencyError = error ResiliencyError("Mocking ResiliencyError");
    AllRetryAttemptsFailed allRetryAttemptsFailed = error AllRetryAttemptsFailed("Mocking AllRetryAttemptsFailed");

    test:assertTrue(checkErrorForRetry(cancelledError, errorTypes));
    test:assertTrue(checkErrorForRetry(unKnownError, errorTypes));
    test:assertTrue(checkErrorForRetry(invalidArgumentError, errorTypes));
    test:assertTrue(checkErrorForRetry(deadlineExceededError, errorTypes));
    test:assertTrue(checkErrorForRetry(notFoundError, errorTypes));
    test:assertTrue(checkErrorForRetry(alreadyExistsError, errorTypes));
    test:assertTrue(checkErrorForRetry(permissionDeniedError, errorTypes));
    test:assertTrue(checkErrorForRetry(unauthenticatedError, errorTypes));
    test:assertTrue(checkErrorForRetry(resourceExhaustedError, errorTypes));
    test:assertTrue(checkErrorForRetry(failedPreconditionError, errorTypes));
    test:assertTrue(checkErrorForRetry(abortedError, errorTypes));
    test:assertTrue(checkErrorForRetry(outOfRangeError, errorTypes));
    test:assertTrue(checkErrorForRetry(unimplementedError, errorTypes));
    test:assertTrue(checkErrorForRetry(internalError, errorTypes));
    test:assertTrue(checkErrorForRetry(dataLossError, errorTypes));
    test:assertTrue(checkErrorForRetry(unavailableError, errorTypes));
    test:assertTrue(checkErrorForRetry(resiliencyError, errorTypes));
    test:assertTrue(checkErrorForRetry(allRetryAttemptsFailed, errorTypes));

    test:assertFalse(checkErrorForRetry(allRetryAttemptsFailed, negativeErrorTypes));
}

@test:Config {enable: true}
isolated function testGetHeaderWithMissingValue() {
    map<string|string[]> headers = {
        "h1": "v1",
        "h2": []
    };
    string|Error err1 = getHeader(headers, "h3");
    if err1 is string {
        test:assertFail("Expected grpc:Error not found");
    } else {
        test:assertEquals(err1.message(), "Header does not exist for h3");
    }

    string|Error err2 = getHeader(headers, "h2");
    if err2 is string {
        test:assertFail("Expected grpc:Error not found");
    } else {
        test:assertEquals(err2.message(), "Header value does not exist for h2");
    }

    string[]|Error err3 = getHeaders(headers, "h3");
    if err3 is string[] {
        test:assertFail("Expected grpc:Error not found");
    } else {
        test:assertEquals(err3.message(), "Header does not exist for h3");
    }
}

@test:Config {enable: true}
isolated function testGetHeaderWithStringArray() returns Error? {
    map<string|string[]> headers = {
        "h1": "v1",
        "h2": ["v2", "v3"]
    };
    string val = check getHeader(headers, "h2");
    test:assertEquals(val, "v2");
}

@test:Config {enable: true}
isolated function testGetHeadersWithStringArray() returns Error? {
    map<string|string[]> headers = {
        "h1": "v1",
        "h2": ["v2", "v3"]
    };
    string[] val = check getHeaders(headers, "h2");
    test:assertEquals(val, ["v2", "v3"]);
}

@test:Config {enable: true}
isolated function testPrepareAuthError() returns Error? {
    ClientAuthError authError = prepareClientAuthError("Error message", ());
    test:assertEquals(authError.message(), "Error message");
}

@test:Config {enable: true}
isolated function testExtractCredential() returns Error? {
    map<string|string[]> headers = {
        authorization: "sample"
    };
    string|Error err = extractCredential(headers);
    if err is string {
        test:assertFail("Expected grpc:Error not found");
    } else {
        test:assertEquals(err.message(), "Empty authentication header.");
    }
}

@test:Config {enable: true}
isolated function testMatchScopes() returns Error? {
    test:assertTrue(matchScopes("read", "read"));
    test:assertTrue(matchScopes(["read", "write", "execute"], "write"));
    test:assertTrue(matchScopes("write", ["read", "write", "execute"]));
    test:assertTrue(matchScopes(["read", "write", "execute"], ["read", "write", "execute"]));
    test:assertFalse(matchScopes(["write", "execute"], ["read"]));
    test:assertFalse(matchScopes(["write", "execute"], "read"));
}

@test:Config {enable: true}
function testConvertToArrayNegativeError() returns Error? {
    string[] result = convertToArray("");
    test:assertEquals(result, []);
}

@test:Config {enable: true}
function testGetHeadersError() returns Error? {
    map<string|string[]> headerMap = {"testHeader": "ABC"};
    string[] result = check getHeaders(headerMap, "testHeader");
    test:assertEquals(result, ["ABC"]);
}

@test:Config {enable: true}
function testGetEmptyDeadline() returns error? {
    map<string|string[]> headerMap = {};
    time:Utc? result = check getDeadline(headerMap);
    test:assertEquals(result, ());
}

@test:Config {enable: true}
function testIsCancelledWithSameTime() returns error? {
    map<string|string[]> headerMap = {"deadline": time:utcToString(time:utcNow())};
    boolean result = check isCancelled(headerMap);
    test:assertTrue(result);
}

@test:Config {enable: true}
function testHello55BearerTokenInit() returns error? {
    string JWT1 = "eyJhbGciOiJSUzI1NiIsICJ0e";
    BearerTokenConfig btConfig = {
        token: JWT1
    };

    ClientAuthHandler authHandler = initClientAuthHandler(btConfig);
    test:assertTrue(authHandler is ClientBearerTokenAuthHandler);
}

@test:Config {enable: true}
function testHello55BearerTokenEnrich() returns error? {
    string jwt = "eyJhbGciOiJSUzI1NiIsICJ0e";
    BearerTokenConfig btConfig = {
        token: jwt
    };

    ClientAuthHandler authHandler = initClientAuthHandler(btConfig);
    map<string|string[]> result = check enrichHeaders(authHandler, {});
    test:assertEquals(result, {"authorization": ["Bearer " + jwt]});
}

@test:Config {enable: true}
function testAuthDesugarNoHeader() returns error? {
    Service authService = @ServiceConfig {auth: []}
    @Descriptor {value: "TEST"}
    service object {
    };

    error? result = trap authenticateResource(authService);
    if result is error {
        test:assertEquals(result.message(), "Authorization header does not exist");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testAuthDesugarFileStoreNegative() returns error? {
    FileUserStoreConfigWithScopes config = {
        fileUserStoreConfig: {},
        scopes: ""
    };
    error? result = authenticateWithFileUserStoreConfig(config, {"authorization": ""});
    if result is error {
        test:assertEquals(result.message(), "Empty authentication header.");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testAuthDesugarFileStorePermissionDenied() returns error? {
    CredentialsConfig cConfig = {
        username: "admin",
        password: "123"
    };

    ClientAuthHandler authHandler = initClientAuthHandler(cConfig);
    map<string|string[]> headers = check enrichHeaders(authHandler, {});

    FileUserStoreConfigWithScopes config = {
        fileUserStoreConfig: {},
        scopes: "edit"
    };
    error? result = authenticateWithFileUserStoreConfig(config, headers);
    if result is error {
        test:assertEquals(result.message(), "Permission denied");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testAuthDesugarLdapStoreNegative() returns error? {
    if !isWindowsEnvironment() {
        LdapUserStoreConfigWithScopes config = {
            ldapUserStoreConfig: {
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
            },
            scopes: "read"
        };

        error? result = authenticateWithLdapUserStoreConfig(config, {"authorization": ""});
        if result is error {
            test:assertEquals(result.message(), "Empty authentication header.");
        } else {
            test:assertFail("Expected an error");
        }
    }
}

@test:Config {enable: true}
function testAuthDesugarLdapStorePermissionDenied() returns error? {
    if !isWindowsEnvironment() {
        CredentialsConfig cConfig = {
            username: "alice",
            password: "alice@123"
        };

        ClientAuthHandler authHandler = initClientAuthHandler(cConfig);
        map<string|string[]> headers = check enrichHeaders(authHandler, {});

        LdapUserStoreConfigWithScopes config = {
            ldapUserStoreConfig: {
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
            },
            scopes: "edit"
        };
        error? result = authenticateWithLdapUserStoreConfig(config, headers);
        if result is error {
            test:assertEquals(result.message(), "Permission denied");
        } else {
            test:assertFail("Expected an error");
        }
    }
}

@test:Config {enable: true}
function testAuthDesugarOAuth2IntrospectionNegative() returns error? {
    OAuth2IntrospectionConfigWithScopes config = {
        oauth2IntrospectionConfig: {
            url: "https://localhost:9401/oauth2/token/introspect",
            tokenTypeHint: "access_token",
            scopeKey: "scp",
            clientConfig: {
                secureSocket: {
                    cert: {
                        path: "tests/resources/ballerinaTruststore.p12",
                        password: "ballerina"
                    }
                }
            }
        },
        scopes: "read"
    };

    error? result = authenticateWithOAuth2IntrospectionConfig(config, {"authorization": ""});
    if result is error {
        test:assertEquals(result.message(), "Empty authentication header.");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testOAuth2HandlerEnrichNegative() returns error? {
    OAuth2GrantConfig config = {
        tokenUrl: "https://localhost:9401/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        scopes: ["write"],
        clientConfig: {
            secureSocket: {
                cert: {
                    path: "tests/resources/ballerinaTruststore.p12",
                    password: "ballerina"
                }
            }
        }
    };

    http:Listener oauth2Listener = check new (oauth2AuthorizationServerPort, {
        secureSocket: {
            key: {
                path: "tests/resources/ballerinaKeystore.p12",
                password: "ballerina"
            }
        }
    });

    check oauth2Listener.attach(oauth2Service, "/oauth2");
    check oauth2Listener.'start();

    ClientOAuth2Handler handler = new (config);
    check oauth2Listener.immediateStop();
    runtime:sleep(5);
    map<string|string[]>|error result = handler->enrich({});
    if result is error {
        test:assertEquals(result.message(), "Failed to enrich request with OAuth2 token. Failed to generate OAuth2 token.");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testJwtAuthHandlerEnrichNegative() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: {"scope": "delete"},
        signatureConfig: {
            config: {
                keyStore: {
                    path: "tests/resources/ballerinaKeystore.p13",
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };

    ClientSelfSignedJwtAuthHandler handler = new (config);
    map<string|string[]>|error result = handler.enrich({});
    if result is error {
        test:assertEquals(result.message(), "Failed to enrich request with JWT. Failed to generate a self-signed JWT.");
    } else {
        test:assertFail("Expected an error");
    }
}

http:Service oauth2Service = service object {
    resource isolated function post token(http:Caller caller, http:Request request) {
        http:Response res = new;
        json response = {
            "access_token": ACCESS_TOKEN,
            "token_type": "example",
            "expires_in": 2,
            "example_parameter": "example_value"
        };
        res.setPayload(response);
        checkpanic caller->respond(res);
    }

    resource isolated function post token/refresh(http:Caller caller, http:Request request) {
        http:Response res = new;
        json response = {
            "access_token": ACCESS_TOKEN,
            "token_type": "example",
            "expires_in": 2,
            "example_parameter": "example_value"
        };
        res.setPayload(response);
        checkpanic caller->respond(res);
    }

    resource isolated function post token/introspect(http:Caller caller, http:Request request) {
        string|http:ClientError payload = request.getTextPayload();
        json response = ();
        if payload is string {
            string[] parts = re`&`.split(payload);
            foreach string part in parts {
                if part.indexOf("token=") is int {
                    string token = re`=`.split(part)[1];
                    if token == ACCESS_TOKEN {
                        response = {"active": true, "exp": 2, "scp": "read write"};
                    } else {
                        response = {"active": false};
                    }
                    break;
                }
            }
        }
        http:Response res = new;
        res.setPayload(response);
        checkpanic caller->respond(res);
    }
};

isolated function isWindowsEnvironment() returns boolean = @java:Method {
    name: "isWindowsEnvironment",
    'class: "io.ballerina.stdlib.grpc.testutils.EnvironmentTestUtils"
} external;
