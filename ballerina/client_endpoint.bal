// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/crypto;
import ballerina/lang.runtime as runtime;
import ballerina/jballerina.java;

# The base client used in the generated client code to provide the capability for initiating the contact and executing remote calls with a remote gRPC service.
public isolated client class Client {

    private final readonly & ClientConfiguration config;
    private string url;
    private final ClientAuthHandler? clientAuthHandler;

    # Gets invoked to initialize the endpoint. During the initialization, the configurations provided through the `config`
    # record are used for the endpoint initialization.
    # ```ballerina
    # HelloWorldClient helloWorldClient = check new("http://localhost:9091");
    # ```
    #
    # + url - The server URL
    # + config - - The client endpoint configurations
    # + return - A `grpc:Error` if an error occurs while initializing the client or else `()`
    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.config = config.cloneReadOnly();
        self.url = url;
        if config.auth is ClientAuthConfig {
            self.clientAuthHandler = initClientAuthHandler(<ClientAuthConfig>config.auth);
        } else {
            self.clientAuthHandler = ();
        }
        lock {
            return externInit(self, self.url, self.config, globalGrpcClientConnPool, config.toString());
        }
    }

    # Calls when initializing the client endpoint with the service descriptor data extracted from the proto file.
    # ```ballerina
    # grpc:Error? result = grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    # ```
    #
    # + clientEndpoint - Client endpoint
    # + descriptorKey - Key of the proto descriptor
    # + descriptorMap - Proto descriptor map with all the dependent descriptors
    # + return - A `grpc:Error` if an error occurs while initializing the stub or else `()`
    public isolated function initStub(AbstractClientEndpoint clientEndpoint, string descriptorKey,
                            map<any> descriptorMap = {}) returns Error? {
                                return externInitStub(self, clientEndpoint, descriptorKey, descriptorMap);
    }

    # Calls when executing a unary gRPC service.
    # ```ballerina
    # [anydata, map<string|string[]>]|grpc:Error result = grpcClient->executeSimpleRPC("HelloWorld/hello", req, headers);
    # ```
    #
    # + methodID - Remote service method ID
    # + payload - Request message. The message type varies with the remote service method parameter
    # + headers - Optional headers parameter. The header value are passed only if needed. The default value is `()`
    # + return - The response as an `anydata` type value or else a `grpc:Error`
    isolated remote function executeSimpleRPC(string methodID, anydata payload, map<string|string[]> headers = {})
                                    returns ([anydata, map<string|string[]>]|Error) {
        var retryConfig = self.config.retryConfiguration;
        map<string|string[]> enrichedHeaders = headers;
        if self.clientAuthHandler is ClientAuthHandler {
            enrichedHeaders = check enrichHeaders(<ClientAuthHandler>self.clientAuthHandler, headers);
        }
        if retryConfig is RetryConfiguration {
            return retryBlockingExecute(self, methodID, payload, enrichedHeaders, retryConfig);
        }
        return externExecuteSimpleRPC(self, methodID, payload, enrichedHeaders);
    }

    # Calls when executing a server streaming call with a gRPC service.
    # ```ballerina
    # [stream<anydata, grpc:Error?>, map<string|string[]>]|grpc:Error result = grpcClient->executeServerStreaming("HelloWorld/hello", req, headers);
    # ```
    #
    # + methodID - Remote service method ID
    # + payload - Request message. The message type varies with the remote service method parameter
    # + headers - Optional headers parameter. The header value are passed only if needed. The default value is `()`
    # + return - A `stream<anydata, grpc:Error?>` or a `grpc:Error` when an error occurs while sending the request
    isolated remote function executeServerStreaming(string methodID, anydata payload, map<string|string[]> headers = {})
                                    returns [stream<anydata, Error?>, map<string|string[]>]|Error {
        map<string|string[]> enrichedHeaders = headers;
        if self.clientAuthHandler is ClientAuthHandler {
            enrichedHeaders = check enrichHeaders(<ClientAuthHandler>self.clientAuthHandler, headers);
        }
        return externExecuteServerStreaming(self, methodID, payload, enrichedHeaders);
    }

    # Calls when executing a client streaming call with a gRPC service.
    # ```ballerina
    # grpc:StreamingClient|grpc:Error result = grpcClient->executeClientStreaming("HelloWorld/hello", headers);
    # ```
    #
    # + methodID - Remote service method ID
    # + headers - Optional headers parameter. The header value are passed only if needed. The default value is `()`
    # + return - A `grpc:StreamingClient` object or a `grpc:Error` when an error occurs
    isolated remote function executeClientStreaming(string methodID, map<string|string[]> headers = {}) returns StreamingClient|Error {
        map<string|string[]> enrichedHeaders = headers;
        if self.clientAuthHandler is ClientAuthHandler {
            enrichedHeaders = check enrichHeaders(<ClientAuthHandler>self.clientAuthHandler, headers);
        }
        return externExecuteClientStreaming(self, methodID, enrichedHeaders);
    }

    # Calls when executing a bi-directional streaming call with a gRPC service.
    # ```ballerina
    # grpc:StreamingClient|grpc:Error result = grpcClient->executeBidirectionalStreaming("HelloWorld/hello", headers);
    # ```
    #
    # + methodID - Remote service method ID
    # + headers - Optional headers parameter. The header value are passed only if needed. The default value is `()`
    # + return - A `grpc:StreamingClient` object or a `grpc:Error` when an error occurs
    isolated remote function executeBidirectionalStreaming(string methodID, map<string|string[]> headers = {}) returns StreamingClient|Error {
        map<string|string[]> enrichedHeaders = headers;
        if self.clientAuthHandler is ClientAuthHandler {
            enrichedHeaders = check enrichHeaders(<ClientAuthHandler>self.clientAuthHandler, headers);
        }
        return externExecuteBidirectionalStreaming(self, methodID, enrichedHeaders);
    }
}

isolated function retryBlockingExecute(Client grpcClient, string methodID, anydata payload, map<string|string[]>
headers, RetryConfiguration retryConfig) returns ([anydata, map<string|string[]>]|Error) {
    int currentRetryCount = 0;
    int retryCount = retryConfig.retryCount;
    decimal interval = retryConfig.interval * 1000;
    decimal maxInterval = retryConfig.maxInterval * 1000;
    decimal backoffFactor = retryConfig.backoffFactor;
    ErrorType[] errorTypes = retryConfig.errorTypes;
    error? cause = ();

    while currentRetryCount <= retryCount {
        [anydata, map<string|string[]>]|Error result = externExecuteSimpleRPC(grpcClient, methodID, payload, headers);
        if result is [anydata, map<string|string[]>] {
            return result;
        } else {
            if !(checkErrorForRetry(result, errorTypes)) {
                return result;
            } else {
                cause = result;
            }
        }
        runtime:sleep(interval);
        decimal newInterval = interval * backoffFactor;
        interval = (newInterval > maxInterval) ? maxInterval : newInterval;
        currentRetryCount += 1;
    }
    if cause is error {
        return error AllRetryAttemptsFailed("Maximum retry attempts completed without getting a result", cause);
    } else {
        return error AllRetryAttemptsFailed("Maximum retry attempts completed without getting a result");
    }
}

isolated function generateMethodId(string? pkgName, string svcName, string rpcName) returns string {
    string methodID;
    if pkgName is () {
        methodID = svcName + "/" + rpcName;
    } else {
        methodID = pkgName + "." + svcName + "/" + rpcName;
    }
    return methodID;
}

// Initialize the client auth handler based on the provided configurations
isolated function initClientAuthHandler(ClientAuthConfig authConfig) returns ClientAuthHandler {
    if authConfig is CredentialsConfig {
        ClientBasicAuthHandler handler = new (authConfig);
        return handler;
    } else if authConfig is BearerTokenConfig {
        ClientBearerTokenAuthHandler handler = new (authConfig);
        return handler;
    } else if authConfig is JwtIssuerConfig {
        ClientSelfSignedJwtAuthHandler handler = new (authConfig);
        return handler;
    } else {
        // Here, `authConfig` is `OAuth2GrantConfig`
        ClientOAuth2Handler handler = new (authConfig);
        return handler;
    }
}

// Enriches the request using the relevant client auth handler
isolated function enrichHeaders(ClientAuthHandler clientAuthHandler, map<string|string[]> headers) returns map<string|string[]>|ClientAuthError {
    if clientAuthHandler is ClientBasicAuthHandler {
        return clientAuthHandler.enrich(headers);
    } else if clientAuthHandler is ClientBearerTokenAuthHandler {
        return clientAuthHandler.enrich(headers);
    } else if clientAuthHandler is ClientSelfSignedJwtAuthHandler {
        return clientAuthHandler.enrich(headers);
    } else if clientAuthHandler is ClientOAuth2Handler {
        return clientAuthHandler->enrich(headers);
    } else {
        string errorMsg = "Invalid client auth-handler found. Expected one of grpc:ClientBasicAuthHandler|grpc:ClientBearerTokenAuthHandler|grpc:ClientSelfSignedJwtAuthHandler|grpc:ClientOAuth2Handler.";
        panic error ClientAuthError(errorMsg);
    }
}

isolated function externInit(Client clientEndpoint, string url, ClientConfiguration config, PoolConfiguration
globalPoolConfig, string optionString)
                returns Error? = @java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.client.FunctionUtils"
} external;

isolated function externInitStub(Client genericEndpoint, AbstractClientEndpoint clientEndpoint, string descriptorKey,
                                map<any> descriptorMap) returns Error? = @java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.client.FunctionUtils"
} external;

isolated function externExecuteSimpleRPC(Client clientEndpoint, string methodID, anydata payload, map<string|string[]> headers)
                returns [anydata, map<string|string[]>]|Error = @java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.client.FunctionUtils"
} external;

isolated function externExecuteServerStreaming(Client clientEndpoint, string methodID, anydata payload,
                map<string|string[]> headers) returns [stream<anydata, Error?>, map<string|string[]>]|Error = @java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.client.FunctionUtils"
} external;

isolated function externExecuteClientStreaming(Client clientEndpoint, string methodID, map<string|string[]> headers)
                returns StreamingClient|Error = @java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.client.FunctionUtils"
} external;

isolated function externExecuteBidirectionalStreaming(Client clientEndpoint, string methodID, map<string|string[]> headers)
                returns StreamingClient|Error = @java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.client.FunctionUtils"
} external;

# Represents the abstract gRPC client endpoint. This abstract object is used in the generated client.
public type AbstractClientEndpoint object {
};

final ErrorType[] & readonly defaultErrorTypes = [InternalError];

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

# Configurations for managing the gRPC client endpoint.
#
# + timeout - The maximum time to wait(in seconds) for a response before closing the connection
# + poolConfig - Connection pool configuration
# + secureSocket - SSL/TLS related options
# + compression - Specifies the way of handling compression (`accept-encoding`) header
# + retryConfiguration - Configures the retry functionality
# + auth - Configurations related to client authentication
# + maxInboundMessageSize - The maximum message size to be permitted for inbound messages. Default value is 4 MB
public type ClientConfiguration record {|
    decimal timeout = 60;
    PoolConfiguration? poolConfig = ();
    ClientSecureSocket? secureSocket = ();
    Compression compression = COMPRESSION_AUTO;
    RetryConfiguration? retryConfiguration = ();
    ClientAuthConfig? auth = ();
    int maxInboundMessageSize = 4194304;
|};

# Configurations for facilitating secure communication with a remote gRPC endpoint.
#
# + enable - Enable SSL validation
# + cert - Configurations associated with the `crypto:TrustStore` or a single certificate file that the client trusts
# + key - Configurations associated with `crypto:KeyStore` or combination of certificate and private key of the client
# + protocol - SSL/TLS protocol related options
# + certValidation - Certificate validation against OCSP_CRL, OCSP_STAPLING related options
# + ciphers - List of ciphers to be used
# eg: TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
# + verifyHostName - Enable/disable host name verification
# + shareSession - Enable/disable new SSL session creation
# + handshakeTimeout - SSL handshake time out(in seconds)
# + sessionTimeout - SSL session time out(in seconds)
public type ClientSecureSocket record {|
    boolean enable = true;
    crypto:TrustStore|string cert?;
    crypto:KeyStore|CertKey key?;
    record {|
        Protocol name;
        string[] versions = [];
    |} protocol?;
    record {|
        CertValidationType 'type = OCSP_STAPLING;
        int cacheSize;
        int cacheValidityPeriod;
    |} certValidation?;
    string[] ciphers?;
    boolean verifyHostName = true;
    boolean shareSession = true;
    decimal handshakeTimeout?;
    decimal sessionTimeout?;
|};
