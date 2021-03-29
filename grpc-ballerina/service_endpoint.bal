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
import ballerina/jballerina.java;

# Represents server listener where one or more services can be registered. so that ballerina program can offer
# service through this listener.
public class Listener {

    private int port = 0;
    private ListenerConfiguration config = {};

    # Starts the registered service.
    # ```ballerina
    # error? result = listenerEp.'start();
    # ```
    #
    # + return - An `error` if an error occurs while starting the server or else `()`
    public isolated function 'start() returns error? {
        return externStart(self);
    }

    # Stops the service listener gracefully. Already-accepted requests will be served before the connection closure.
    # ```ballerina
    # error? result = listenerEp.gracefulStop();
    # ```
    #
    # + return - An `error` if an error occurred during the listener stopping process or else `()`
    public isolated function gracefulStop() returns error? {
        return ();
    }

    # Stops the registered service.
    # ```ballerina
    # error? result = listenerEp.immediateStop();
    # ```
    #
    # + return - An `error` if an error occurs while stopping the server or else `()`
    public isolated function immediateStop() returns error? {
        return externStop(self);
    }

    # Gets called every time a service attaches itself to this endpoint - also happens at module init time.
    # ```ballerina
    # error? result = listenerEp.attach(helloService);
    # ```
    #
    # + s - The type of the service to be registered
    # + name - Name of the service
    # + return - An `error` if encounters an error while attaching the service or else `()`
    public isolated function attach(Service s, string[]|string? name = ()) returns error? {
        return externRegister(self, s, name);
    }

    # Detaches an HTTP or WebSocket service from the listener. Note that detaching a WebSocket service would not affect
    # the functionality of the existing connections.
    # ```ballerina
    # error? result = listenerEp.detach(helloService);
    # ```
    #
    # + s - The service to be detached
    # + return - An `error` if occurred during detaching of a service or else `()`
    public isolated function detach(Service s) returns error? {
    }

    # Gets called when the endpoint is being initialized during the module init time.
    #
    # + port - Listener port
    # + config - The `grpc:ListenerConfiguration` of the endpoint
    public isolated function init(int port, *ListenerConfiguration config) returns error? {
        self.config = config;
        self.port = port;
        return externInitEndpoint(self);
    }
}

# The gRPC service type
public type Service service object {

};

# The stream iterator object that is used to iterate through the stream messages.
#
class StreamIterator {
    private boolean isClosed = false;

    public isolated function next() returns record {|anydata value;|}|error? {
        if (self.isClosed) {
            return error StreamClosedError("Stream is closed. Therefore, no operations are allowed further on the stream.");
        }
        anydata|handle|error? result = nextResult(self);
        if (result is anydata) {
            if (result is ()) {
                self.isClosed = true;
                return result;
            }
            return {value: result};
        } else if (result is handle) {
            return {value: java:toString(result)};
        } else {
            return result;
        }
    }

    public isolated function close() returns error? {
        if (!self.isClosed) {
            self.isClosed = true;
            return closeStream(self);
        } else {
            return error StreamClosedError("Stream is closed. Therefore, no operations are allowed further on the stream.");
        }
    }
}

isolated function externInitEndpoint(Listener listenerObject) returns error? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.serviceendpoint.FunctionUtils"
} external;

isolated function externRegister(Listener listenerObject, service object {} serviceType, string[]|string? name) returns error? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.serviceendpoint.FunctionUtils"
} external;

isolated function externStart(Listener listenerObject) returns error? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.serviceendpoint.FunctionUtils"
} external;

isolated function externStop(Listener listenerObject) returns error? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.serviceendpoint.FunctionUtils"
} external;

isolated function nextResult(StreamIterator iterator) returns anydata|handle|error? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.serviceendpoint.FunctionUtils"
} external;

isolated function closeStream(StreamIterator iterator) returns error? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.serviceendpoint.FunctionUtils"
} external;

# Maximum number of requests that can be processed at a given time on a single connection.
const int MAX_PIPELINED_REQUESTS = 10;

# Constant for the default listener endpoint timeout
const decimal DEFAULT_LISTENER_TIMEOUT = 120; //2 mins

# Represents the gRPC server endpoint configuration.
#
# + host - The server hostname
# + secureSocket - The SSL configurations for the client endpoint
# + timeout - Period of time in seconds that a connection waits for a read/write operation. Use value 0 to
#                   disable the timeout
public type ListenerConfiguration record {|
    string host = "0.0.0.0";
    ListenerSecureSocket? secureSocket = ();
    decimal timeout = DEFAULT_LISTENER_TIMEOUT;
|};

# Configures the SSL/TLS options to be used for HTTP service.
#
# + key - Configurations associated with `crypto:KeyStore` or combination of certificate and private key of the server
# + mutualSsl - Configures associated with mutual SSL operations
# + protocol - SSL/TLS protocol related options
# + certValidation - Certificate validation against OCSP_CRL, OCSP_STAPLING related options
# + ciphers - List of ciphers to be used
#             eg: TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
# + shareSession - Enable/Disable new SSL session creation
# + handshakeTimeout - SSL handshake time out(in seconds)
# + sessionTimeout - SSL session time out(in seconds)
public type ListenerSecureSocket record {|
    crypto:KeyStore|CertKey key;
    record {|
        VerifyClient verifyClient = REQUIRE;
        crypto:TrustStore|string cert;
    |} mutualSsl?;
    record {|
        Protocol name;
        string[] versions = [];
    |} protocol?;
    record {|
        CertValidationType 'type = OCSP_STAPLING;
        int cacheSize;
        int cacheValidityPeriod;
    |} certValidation?;
    string[] ciphers = ["TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256", "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
                        "TLS_DHE_RSA_WITH_AES_128_CBC_SHA256", "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA",
                        "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA", "TLS_DHE_RSA_WITH_AES_128_CBC_SHA",
                        "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256", "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
                        "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256"];
    boolean shareSession = true;
    decimal handshakeTimeout?;
    decimal sessionTimeout?;
|};
