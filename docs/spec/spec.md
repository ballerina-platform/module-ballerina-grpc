# Specification: Ballerina gRPC Library

_Owners_: @shafreenAnfar @daneshk @BuddhiWathsala @MadhukaHarith92 @dilanSachi  
_Reviewers_: @shafreenAnfar @daneshk @dilanSachi  
_Created_: 2021/12/05   
_Updated_: 2021/12/05  
_Issue_: [#2151](https://github.com/ballerina-platform/ballerina-standard-library/issues/2151)

# Introduction
This is the specification for gRPC standard library, which provides gRPC functionalities in the [Ballerina programming language](https://ballerina.io/), which is an open-source programming language for the cloud
that makes it easier to use, combine, and create network services.

# Contents
1. [Overview](#1-overview)
2. [gRPC Command Line Interface (CLI)](#1-grpc-command-line-interface-cli)
3. [Protocol Buffers to Ballerina Data Mapping](#3-protocol-buffers-to-ballerina-data-mapping)
4. [gRPC Communication](#4-grpc-communication)
   * 4.1. [Unary RPC](#41-unary-rpc)
   * 4.2. [Server Streaming RPC](#42-server-streaming-rpc)
   * 4.3. [Client Streaming RPC](#43-client-streaming-rpc)
   * 4.4. [Bidirectional Streaming RPC](#44-bidirectional-streaming-rpc)
5. [gRPC Security](#51-authentication-and-authorization)
   * 5.1. [Authentication and Authorization](#51-authentication-and-authorization)
      * 5.1.1. [Declarative Approach](#511-declarative-approach)
         * 5.1.1.1. [Service - File User Store](#5111-service-file-user-store)
         * 5.1.1.2. [Service - LDAP User Store](#5112-service-ldap-user-store)
         * 5.1.1.3. [Service - JWT](#5113-service-jwt)
         * 5.1.1.4. [Service - OAuth2](#5114-service-oauth2)
         * 5.1.1.5. [Client - Basic Auth](#5115-client-basic-auth)
         * 5.1.1.6. [Client - Bearer Token Auth](#5116-client-bearer-token-auth)
         * 5.1.1.7. [Client - Self Signed JWT Auth](#5117-client-self-signed-jwt-auth)
         * 5.1.1.8. [Client - OAuth2](#5118-client-oauth2)
      * 5.1.2 [Imperative Approach](#512-imperative-approach)
         * 5.1.2.1. [Service - File User Store](#5121-service-file-user-store)
         * 5.1.2.2. [Service - LDAP User Store](#5122-service-ldap-user-store)
         * 5.1.2.3. [Service - JWT](#5123-service-jwt)
         * 5.1.2.4. [Service - OAuth2](#5124-service-oauth2)
         * 5.1.2.5. [Client - Basic Auth](#5125-client-basic-auth)
         * 5.1.2.6. [Client - Bearer Token Auth](#5126-client-bearer-token-auth)
         * 5.1.2.7. [Client - Self Signed JWT Auth](#5127-client-self-signed-jwt-auth)
         * 5.1.2.8. [Client - OAuth2](#5128-client-oauth2)
6. [gRPC Utility Functions](#6-grpc-utility-functions)
   * 6.1. [gRPC Deadline](#61-grpc-deadline)
   * 6.2. [gRPC Compression](#62-grpc-compression)
   * 6.3. [gRPC Access and Trace Logs](#63-grpc-access-and-trace-logs)
   * 6.4. [gRPC Retry](#64-grpc-retry)


# 1. Overview
Ballerina gRPC standard library has five primary aspects in handling time values.
1. gRPC CLI (command line interface)
2. Protocol buffers to Ballerina data mapping
3. gRPC communication
4. gRPC Security
5. gRPC utility functions

# 2. gRPC Command Line Interface (CLI)

Ballerina language comes up with a command-line interface that manages the lifecycle of a Ballerina program (such as build, test, and run). In addition, Ballerina CLI contains all the gRPC related stub and service skeleton generation capabilities. The gRPC command in Ballerina CLI is as follows.

```sh
bal grpc --input <proto-file-path> --output <output-directory> --mode client|service
```

The `--input` parameter is the only mandatory for the Ballerina gRPC command, and it specifies the path of the protobuf file of a gRPC service. The optional `--output` parameter indicates the path that output will be written. If the output path is not specified, the output will be written to a directory corresponding to the package in the Protocol Buffers definition. If the package is not specified, the output will be written to a `temp` directory in the current location. The optional `--mode` indicate what type of output files are needed. For example, if mode specifies as service, the gRPC command will generate the relevant stub file along with a service skeleton. If the mode is client, the gRPC command will generate a sample client code along with the stub. If nothing is specified, only the stub file is generated.

# 3. Protocol Buffers to Ballerina Data Mapping

The following table illustrates the data mapping of protocol buffers data types to relevant Ballerina types.

|Protobuf Type|Ballerina Type|
|---|---|
|google.protobuf.DoubleValue|float|
|google.protobuf.FloatValue|float|
|google.protobuf.Int64Value|int|
|google.protobuf.UInt64Value|int|
|google.protobuf.Int32Value|int|
|google.protobuf.UInt32Value|int|
|google.protobuf.BoolValue|boolean|
|google.protobuf.StringValue|string|
|google.protobuf.BytesValue|byte[]|
|google.protobuf.Empty|()|
|google.protobuf.Timestamp|time:Utc|
|google.protobuf.Duration|time:Seconds|
|google.protobuf.Any|'any:Any|

Note that here the `'any` is the namespace of the `ballerina/protobuf.types.'any` submodule. Additionally, the `google.protobuf.Any` need serialization and deserialization mechanisms. To do that, `ballerina/protobuf.types.'any` module contains two APIs called pack and unpack to serialize and deserialize `Any` type records.

```ballerina
# Generate and return the generic `'any:Any` record that is used to represent protobuf `Any` type.
#
# + message - The record or the scalar value to be packed as Any type
# + return - Any value representation of the given message
public isolated function pack(ValueType message) returns Any;

# Unpack and return the specified Ballerina value
#
# + anyValue - Any value to be unpacked
# + targetTypeOfAny - Type descriptor of the return value
# + return - Return a value of the given type
public isolated function unpack(Any anyValue, ValueTypeDesc targetTypeOfAny = <>) returns targetTypeOfAny|Error;
```

# 4. gRPC Communication

gRPC has 4 types of RPCs (Remote Procedure Calls), and Ballerina supports all of them.
1. Unary
2. Server streaming
3. Client streaming
4. Bidirectional streaming

Note that, to explain the behaviour of these 4 RPC types, this document uses the standard Route Guide example.
- [Details of the route guide example](https://grpc.io/docs/languages/go/basics/)
- [Protocol buffer definition of the route guide example](https://github.com/ballerina-platform/module-ballerina-grpc/blob/674bda12a90f99c2735badc5567cd7dd7e14ba09/examples/routeguide/proto-file/route_guide.proto)

## 4.1. Unary RPC

The RPC service definition of a unary call is as follows.
```proto
service RouteGuide {
    rpc GetFeature(Point) returns (Feature) {}
}
```
The Ballerina service implementation of a gRPC can be done in two ways.
1. Using direct returning
2. Using a caller

Directly returning the response is the most convenient implementation. However, for asynchronous RPC calls, directly returning is not suitable, and for such use cases, using a caller is the ideal approach. In addition, each RPC call (unary, server streaming, client streaming, and bidirectional streaming) can be implemented in both ways.

**RPC Using Direct Return**

Ballerina CLI generates the relevant service skeleton, and the implementation of the unary RPC call using direct return is as follows.

```ballerina
service "RouteGuide" on new grpc:Listener(8980) {

    remote function GetFeature(Point point) returns Feature|error {
        foreach Feature feature in FEATURES {
            if feature.location == point {
                return feature;
            }
        }
        return {location: point, name: ""};
    }
}
```

Here, the RPC implementation creates a featured record and directly return it from the remote method.

**RPC Using a Caller**
The Ballerina implementation of the same unary RPC using a caller is as follows.

```ballerina
service "RouteGuide" on new grpc:Listener(8980) {

    remote function GetFeature(RouteGuideFeatureCaller caller, Point point) returns error? {
        Feature?|error feature = featureFromPoint(point);
        if feature is Feature {
            check caller->sendFeature(feature);
        } else if feature is error {
            check caller->sendError(<grpc:Error> feature);
        } else {
            check caller->sendFeature({location: {latitude: 0, longitude: 0}, name: ""});
        }
    }
}
```

## 4.2. Server Streaming RPC
The RPC service definition of a server streaming call is as follows.
```proto
service RouteGuide {
    rpc ListFeatures(Rectangle) returns (stream Feature) {}
}
```

**RPC Using Direct Return**
The Ballerina implementation of the server streaming RPC using a direct return is as follows.

```ballerina
service "RouteGuide" on new grpc:Listener(8980) {

    remote function ListFeatures(Rectangle rectangle) returns stream<Feature, grpc:Error?>|error {

        Feature[] selectedFeatures = [];
        foreach Feature feature in FEATURES {
            if inRange(feature.location, rectangle) {
                selectedFeatures.push(feature);
            }
        }
        return selectedFeatures.toStream();
    }
}
```

**RPC Using a Caller**
The Ballerina implementation of the server streaming RPC using a caller return is as follows.

```ballerina
service "RouteGuide" on new grpc:Listener(8980) {

    remote function ListFeatures(RouteGuideFeatureCaller caller, Rectangle rectangle) returns error? {

        foreach Feature feature in FEATURES {
            if inRange(feature.location, rectangle) {
                check caller->sendFeature(feature);
            }
        }
    }
}
```

## 4.3. Client Streaming RPC
The RPC service definition of a client streaming call is as follows.
```proto
service RouteGuide {
    rpc RecordRoute(stream Point) returns (RouteSummary) {}
}
```

**RPC Using Direct Return**
The Ballerina implementation of the client streaming RPC using a direct return is as follows.

```ballerina
service "RouteGuide" on new grpc:Listener(8980) {

    remote function RecordRoute(stream<Point, grpc:Error?> clientStream) returns RouteSummary|error {
        Point? lastPoint = ();
        int pointCount = 0;
        int featureCount = 0;
        int distance = 0;

        decimal startTime = time:monotonicNow();
        check clientStream.forEach(function(Point p) {
            pointCount += 1;
            if pointExistsInFeatures(FEATURES, p) {
                featureCount += 1;
            }

            if lastPoint is Point {
                distance = calculateDistance(<Point>lastPoint, p);
            }
            lastPoint = p;
        });
        decimal endTime = time:monotonicNow();
        int elapsedTime = <int>(endTime - startTime);
        return {point_count: pointCount, feature_count: featureCount, distance: distance, elapsed_time: elapsedTime};
    }
}
```

**RPC Using a Caller**
The Ballerina implementation of the client streaming RPC using a caller return is as follows.

```ballerina
service "RouteGuide" on new grpc:Listener(8980) {

    remote function RecordRoute(RouteGuideRouteSummaryCaller caller, stream<Point, grpc:Error?> clientStream) returns error? {
        Point? lastPoint = ();
        int pointCount = 0;
        int featureCount = 0;
        int distance = 0;

        decimal startTime = time:monotonicNow();
        check clientStream.forEach(function(Point p) {
            pointCount += 1;
            if pointExistsInFeatures(FEATURES, p) {
                featureCount += 1;
            }

            if lastPoint is Point {
                distance = calculateDistance(<Point>lastPoint, p);
            }
            lastPoint = p;
        });
        decimal endTime = time:monotonicNow();
        int elapsedTime = <int>(endTime - startTime);
        return caller->sendRouteSummary({point_count: pointCount, feature_count: featureCount, distance: distance, elapsed_time: elapsedTime});
    }
}
```

## 4.4. Bidirectional Streaming RPC
The RPC service definition of a bidirectional streaming call is as follows.
```proto
service RouteGuide {
    rpc ListFeatures(Rectangle) returns (stream Feature) {}
}
```

**RPC Using Direct Return**
The Ballerina implementation of the bidirectional streaming RPC using a direct return is as follows.

```ballerina
service "RouteGuide" on new grpc:Listener(8980) {

    remote function RouteChat(stream<RouteNote, grpc:Error?> clientNotesStream) returns stream<RouteNote, grpc:Error?>|error {
        RouteNote[] routeNotes = [];
        check clientNotesStream.forEach(function(RouteNote note) {
            ROUTE_NOTES.push(note);
            foreach RouteNote n in ROUTE_NOTES {
                if n.location == note.location {
                    routeNotes.push(note);
                }
            }
        });
        return routeNotes.toStream();
    }
}
```

Note that, here using direct return will not address the exact use case. This example was added, only for completeness.

**RPC Using a Caller**
The Ballerina implementation of the bidirectional streaming RPC using a caller return is as follows.

```ballerina
service "RouteGuide" on new grpc:Listener(8980) {

    remote function RouteChat(RouteGuideRouteNoteCaller caller, stream<RouteNote, grpc:Error?> clientNotesStream) returns error? {
        check clientNotesStream.forEach(function(RouteNote note) {
            future<error?> f1 = start sendRouteNotesFromLocation(caller, note.location);
            lock {
                ROUTE_NOTES.push(note);
            }
            error? waitErr = wait f1;
        });
    }
}
```

# 5. gRPC Security

## 5.1 Authentication and Authorization

There are two ways to enable authentication and authorization in gRPC.
1. Declarative approach
2. Imperative approach

### 5.1.1 Declarative Approach

This is also known as the configuration-driven approach, which is used for simple use cases, where users have to provide a set of configurations and do not need to be worried more about how authentication and authorization works. The user does not have full control over the configuration-driven approach.

The service and/or resource configurations are used to define the authentication and authorization configurations. Users can configure the configurations needed for different authentication schemes and configurations needed for authorizations of each authentication scheme. Also, the configurations can be provided at both the service and resource levels. The priority will be given from bottom to top. Then, the auth handler creation and request authentication/authorization is handled internally without user intervention. The requests that succeeded both authentication and/or authorization phases according to the configurations will be passed to the business logic layer.

#### 5.1.1.1 Service - File User Store
Ballerina gRPC services enable authentication and authorization using a file user store by setting the `grpc:FileUserStoreConfigWithScopes` configurations in the listener.

```ballerina
@grpc:ServiceConfig {
    auth: [
        {
            fileUserStoreConfig: {},
            scopes: ["admin"]
        }
    ]
}
@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_GRPC_SERVICE,
    descMap: getDescriptorMapGrpcService()
}
service "HelloWorld" on new grpc:Listener(9090) {
    remote function hello() returns string {
        return "Hello, World!";
    }
}
```

```toml
# Config.toml

[[ballerina.auth.users]]
username="alice"
password="alice@123"
scopes=["developer"]

[[ballerina.auth.users]]
username="ldclakmal"
password="ldclakmal@123"
scopes=["developer", "admin"]

[[ballerina.auth.users]]
username="eve"
password="eve@123"
```

#### 5.1.1.2 Service - LDAP User Store
Ballerina gRPC services enable authentication and authorization using an LDAP user store by setting the `grpc:LdapUserStoreConfigWithScopes` configurations in the listener.

```ballerina
@grpc:ServiceConfig {
    auth: [
        {
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
            scopes: ["admin"]
        }
    ]
}
@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_GRPC_SERVICE,
    descMap: getDescriptorMapGrpcService()
}
service "HelloWorld" on new grpc:Listener(9090) {
    remote function hello() returns string {
        return "Hello, World!";
    }
}
```

#### 5.1.1.3 Service - JWT
Ballerina gRPC services enable authentication and authorization using JWTs by setting the `grpc:JwtValidatorConfigWithScopes` configurations in the listener.

```ballerina
@grpc:ServiceConfig {
    auth: [
        {
            jwtValidatorConfig: {
                issuer: "wso2",
                audience: "ballerina",
                signatureConfig: {
                    certFile: "../resource/path/to/public.crt"
                },
                scopeKey: "scp"
            },
            scopes: ["admin"]
        }
    ]
}
@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_GRPC_SERVICE,
    descMap: getDescriptorMapGrpcService()
}
service "HelloWorld" on new grpc:Listener(9090) {
    remote function hello() returns string {
        return "Hello, World!";
    }
}
```

#### 5.1.1.4 Service - OAuth2
Ballerina gRPC services enable authentication and authorization using OAuth2 by setting the `grpc:OAuth2IntrospectionConfigWithScopes` configurations in the listener.

```ballerina
@grpc:ServiceConfig {
    auth: [
        {
            oauth2IntrospectionConfig: {
                url: "https://localhost:9445/oauth2/introspect",
                tokenTypeHint: "access_token",
                scopeKey: "scp",
                clientConfig: {
                    customHeaders: {"Authorization": "Basic YWRtaW46YWRtaW4="},
                    secureSocket: {
                        cert: "../resource/path/to/public.crt"
                    }
                }
            },
            scopes: ["admin"]
        }
    ]
}
@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_GRPC_SERVICE,
    descMap: getDescriptorMapGrpcService()
}
service "HelloWorld" on securedEP {
    remote function hello() returns string {
        return "Hello, World!";
    }
}
```

#### 5.1.1.5 Client - Basic Auth
Ballerina gRPC clients enable basic auth with credentials by setting the `grpc:CredentialsConfig` configurations in the client.

```ballerina
HelloWorldClient securedEP = check new("https://localhost:9090",
    auth = {
        username: "john",
        password: "ballerina@123"
    }
);
```

#### 5.1.1.6 Client - Bearer Token Auth
Ballerina gRPC clients enable authentication using bearer tokens by setting the `grpc:BearerTokenConfig` configurations in the client.

```ballerina 
HelloWorldClient securedEP = check new("https://localhost:9090",
    auth = {
        token: "56ede317-4511-44b4-8579-a08f094ee8c5"
    }
);
```

#### 5.1.1.7 Client - Self Signed JWT Auth
Ballerina gRPC clients enable authentication using JWTs by setting the `grpc:JwtIssuerConfig` configurations in the client.

```ballerina
HelloWorldClient securedEP = check new("https://localhost:9090",
    auth = {
        username: "ballerina",
        issuer: "wso2",
        audience: ["ballerina", "ballerina.org", "ballerina.io"],
        keyId: "5a0b754-895f-4279-8843-b745e11a57e9",
        jwtId: "JlbmMiOiJBMTI4Q0JDLUhTMjU2In",
        customClaims: { "scp": "admin" },
        expTime: 3600,
        signatureConfig: {
            config: {
                keyFile: "../resource/path/to/private.key"
            }
        }
    }
);
```

#### 5.1.1.8 Client - OAuth2
Ballerina gRPC clients enable authentication using OAuth2 by setting the `grpc:OAuth2GrantConfig` configurations in the client. OAuth2 can configure in 4 ways:

**i. Credentials Grant Type**

```ballerina
HelloWorldClient securedEP = check new("https://localhost:9090",
    auth = {
        tokenUrl: "https://localhost:9445/oauth2/token",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["admin"],
        clientConfig: {
            secureSocket: {
                cert: "../resource/path/to/public.crt"
            }
        }
    }
);
```

**ii. Password Grant Type**

```ballerina
HelloWorldClient securedEP = check new("https://localhost:9090",
    auth = {
        tokenUrl: "https://localhost:9445/oauth2/token",
        username: "admin",
        password: "admin",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["admin"],
        refreshConfig: {
            refreshUrl: "https://localhost:9445/oauth2/token",
            scopes: ["hello"],
            clientConfig: {
                secureSocket: {
                    cert: "../resource/path/to/public.crt"
                }
            }
        },
        clientConfig: {
            secureSocket: {
                cert: "../resource/path/to/public.crt"
            }
        }
    }
);
```
**iii. Refresh Token Grant Type**

```ballerina
HelloWorldClient securedEP = check new("https://localhost:9090",
    auth = {
        refreshUrl: "https://localhost:9445/oauth2/token",
        refreshToken: "24f19603-8565-4b5f-a036-88a945e1f272",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["admin"],
        clientConfig: {
            secureSocket: {
                cert: "../resource/path/to/public.crt"
            }
        }
    }
);
```

**iv. JWT Bearer Grant Type**

```ballerina
HelloWorldClient securedEP = check new("https://localhost:9090",
    auth = {
        tokenUrl: "https://localhost:9445/oauth2/token",
        assertion: "eyJhbGciOiJFUzI1NiIsImtpZCI6Ij[...omitted for brevity...]",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["admin"],
        clientConfig: {
            secureSocket: {
                cert: "../resource/path/to/public.crt"
            }
        }
    }
);
```
### 5.1.2 Imperative Approach
This is also known as the code-driven approach, which is used for advanced use cases, where users need to be worried more about how authentication and authorization work and need to have further customizations. The user has full control of the code-driven approach. The handler creation and authentication/authorization calls are made by the user at the business logic layer.

#### 5.1.2.1 Service - File User Store
Ballerina gRPC services enable authentication and authorization using a file user store by employing the class `grpc:ListenerFileUserStoreBasicAuthHandler`.

```ballerina
service "HelloWorld" on new grpc:Listener(9090) {

    remote function sayHello(ContextString request) returns string|error {

        grpc:ListenerFileUserStoreBasicAuthHandler handler = new;
        auth:UserDetails|grpc:UnauthenticatedError authnResult = handler.authenticate(request.headers);

    }
}
```

```toml
# Config.toml
[ballerina.observe]
enabled=true
provider="noop"

[[auth.users]]
username="admin"
password="123"
scopes=["write", "update"]
```

#### 5.1.2.2 Service - LDAP User Store
Ballerina gRPC services enable authentication and authorization using an LDAP user store by employing the class `grpc:ListenerLdapUserStoreBasicAuthHandler`.

```ballerina
service "HelloWorld" on new grpc:Listener(9090) {

    remote function sayHello(ContextString request) returns string|error {

        grpc:LdapUserStoreConfig config = {
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

        grpc:ListenerLdapUserStoreBasicAuthHandler handler = new(config);
        auth:UserDetails|grpc:UnauthenticatedError authnResult = handler->authenticate(request.headers);


    }
}
```
#### 5.1.2.3 Service - JWT
Ballerina gRPC services enable authentication and authorization using JWTs by employing the class `grpc:ListenerJwtAuthHandler`.

```ballerina
service "HelloWorld" on new grpc:Listener(9090) {

    remote function sayHello(ContextString request) returns string|error {

        grpc:JwtValidatorConfig config = {
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

        grpc:ListenerJwtAuthHandler handler = new(config);
        jwt:Payload|grpc:UnauthenticatedError authResult = handler.authenticate(request.headers);
    }
}
```
#### 5.1.2.4 Service - OAuth2
Ballerina gRPC services enable authentication and authorization using OAuth2 by employing the class `grpc:OAuth2IntrospectionConfig`.

```ballerina
service "HelloWorld" on new grpc:Listener(9090) {

    remote function sayHello(ContextString request) returns string|error {

        grpc:OAuth2IntrospectionConfig config = {
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

        grpc:ListenerOAuth2Handler handler = new(config);
        oauth2:IntrospectionResponse|grpc:UnauthenticatedError|grpc:PermissionDeniedError authResult = handler->authorize(request.headers, "read");
    }
}
```
#### 5.1.2.5 Client - Basic Auth
Ballerina gRPC clients enable authentication and authorization using basic auth by employing class `grpc:ClientBasicAuthHandler`. To enable authentication and authorization, the generated headers of the `enrich` API needs to pass to the RPC call.

```ballerina
grpc:CredentialsConfig config = {
    username: "admin",
    password: "123"
};

grpc:ClientBasicAuthHandler handler = new (config);
map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
```
#### 5.1.2.6 Client - Bearer Token Auth
Ballerina gRPC clients enable authentication and authorization using bearer tokens by employing class `grpc:ClientBearerTokenAuthHandler`. To enable authentication and authorization, the generated headers of the `enrich` API needs to pass to the RPC call.

```ballerina
grpc:BearerTokenConfig config = {token: "eyJhbGciOiJSUzI1NiIsICJ0eXAiOiJKV1QifQ"};

grpc:ClientBearerTokenAuthHandler handler = new (config);
map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
```
#### 5.1.2.7 Client - Self Signed JWT Auth
Ballerina gRPC clients enable authentication and authorization using JWTs by employing class `grpc:ClientSelfSignedJwtAuthHandler`. To enable authentication and authorization, the generated headers of the `enrich` API needs to pass to the RPC call.

```ballerina
grpc:JwtIssuerConfig config = {
    username: "admin",
    issuer: "wso2",
    audience: ["ballerina"],
    customClaims: { "scope": "write" },
    signatureConfig: {
        config: {
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            keyAlias: "ballerina",
            keyPassword: "ballerina"
        }
    }
};
grpc:ClientSelfSignedJwtAuthHandler handler = new(config);
map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
```
#### 5.1.2.8 Client - OAuth2
Ballerina gRPC clients enable authentication and authorization using OAuth2 by employing class `grpc:ClientOAuth2Handler`. To enable authentication and authorization, the generated headers of the `enrich` API needs to pass to the RPC call.

```ballerina
grpc:OAuth2ClientCredentialsGrantConfig config = {
    tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
    clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
    clientSecret: "9205371918321623741",
    scopes: ["token-scope1", "token-scope2"],
    clientConfig: {
        secureSocket: {
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            }
        }
    }
};
grpc:ClientOAuth2Handler handler = new(config);
map<string|string[]>|grpc:ClientAuthError result = handler->enrich(requestHeaders);
```

## 5.2 SSL/TLS and Mutual SSL
A gRPC listener with configuration `grpc:ListenerSecureSocket` exposes gRPC services with SSL/TLS.

```ballerina
listener grpc:Listener securedEp = new(9090,
    secureSocket = {
        key: {
            certFile: "./resources/public.crt",
            keyFile: "./resources/private.key"
        }
    }
);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_GRPC_SERVICE,
    descMap: getDescriptorMapGrpcService()
}
service "HelloWorld" on securedEp {
    remote function hello() returns string {
        return "Hello, World!";
    }
}
```
A gRPC client with configuration `grpc:ClientSecureSocket` can invoke gRPC services with SSL/TLS.

```ballerina
HelloWorldClient securedEp = check new("https://localhost:9090",
    secureSocket = {
        cert: "../resource/path/to/public.crt"
    }
);
```

By configuring the mutualSsl entry in the `grpc:ListenerSecureSocket`, gRPC services can expose with mutual SSL.

```ballerina
listener grpc:Listener securedEP = new(9090,
    secureSocket = {
        key: {
            certFile: "../resource/path/to/public.crt",
            keyFile: "../resource/path/to/private.key"
        },

        mutualSsl: {
            verifyClient: grpc:REQUIRE,
            cert: "../resource/path/to/public.crt"
        },

        protocol: {
            name: grpc:TLS,
            versions: ["TLSv1.2", "TLSv1.1"]
        },

        ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]

    }
);
```

# 6. gRPC Utility Functions

# 6.1. gRPC Deadline
The following API sets a deadline for each request.

```ballerina
# Enables the deadline by adding the `deadline` header to the given headers.
# ```ballerina
# time:Utc current = time:utcNow();
# time:Utc deadline = time:utcAddSeconds(current, 300);
# map<string|string[]> headers = grpc:setDeadline(deadline);
# ```
#
# + deadline - The deadline time value (this should be a specific time and not a duration)
# + headerMap - Optional header map (if this is not specified, it creates a new header set)
# + return - The header map that includes the deadline
public isolated function setDeadline(time:Utc deadline, map<string|string[]> headerMap = {}) returns map<string|string[]>;
```

If a particular RPC exceeds the specified deadline, the response will be a `grpc:DeadlineExceededError`.

# 6.2. gRPC Compression
The following API enables compression for gRPC calls. Currently, Gzip compression is supported by the Ballerina gRPC library.
```ballerina
# Enables the compression support by adding the `grpc-encoding` header to the given headers.
# ```ballerina
# map<string|string[]> headers = grpc:setCompression(grpc:GZIP);
# ```
#
# + compressionType - The compression type.
# + headerMap - Optional header map (if this is not specified, it creates a new header set)
# + return - The header map that includes the compression headers
public isolated function setCompression(CompressionType compressionType, map<string|string[]> headerMap = {}) returns map<string|string[]>;
```
# 6.3. gRPC Access and Trace Logs
Access and trace logs can be enabled by adding the following configurations to the `Config.toml` file in a Ballerina project.

```toml
[ballerina.grpc.traceLogAdvancedConfig]
# Enable printing trace logs in console
console = true              # Default is false
# Prints the trace logs to the given file
path = "testTraceLog.txt"   # Optional
# Sends the trace logs to the configured endpoint
host = "localhost"          # Optional
port = 8080                 # Optional

[ballerina.grpc.accessLogConfig]
# Enable printing access logs in console
console = true              # Default is false
# Prints the access logs to the given file
path = "testTraceLog.txt"   # Optional
```

# 6.4. gRPC Retry
Client-level retrying can be enabled by passing the following configurations to the client initialization.

```ballerina
# Configurations for facilitating the retry capability of the gRPC client.
#
# + retryCount - Maximum number of retry attempts in a failure scenario
# + interval - Initial interval(in seconds) between the retry attempts
# + maxInterval - Maximum interval(in seconds) between two retry attempts
# + backoffFactor - Retry interval will be multiplied by this factor, in between retry attempts
# + errorTypes - Error types which should be considered as failure scenarios to retry
public type RetryConfiguration record {|
   int retryCount;
   decimal interval;
   decimal maxInterval;
   decimal backoffFactor;
   ErrorType[] errorTypes = defaultErrorTypes;
|};
```

