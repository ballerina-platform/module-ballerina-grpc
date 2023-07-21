// Copyright (c) 2023 WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

import ballerina/jballerina.java;
import ballerina/test;
import ballerina/grpc;

@test:Config {enable: true}
function testExternInitStubNullRootDescriptor() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeInitStubNullRootDescriptor('client);
    if result is error {
        test:assertEquals(result.message(), "Error while initializing connector. message descriptor keys not exist. " +
        "Please check the generated stub file");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeInitStubNullRootDescriptor(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteSimpleRPCNullClientEndpoint() returns error? {
    error? result = externInvokeExecuteSimpleRPCNullClientEndpoint();
    if result is error {
        test:assertEquals(result.message(), "Error while getting connector. gRPC client connector " +
        "is not initialized properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteSimpleRPCNullClientEndpoint() returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteSimpleRPCNullConnectionStub() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteSimpleRPCNullConnectionStub('client);
    if result is error {
        test:assertEquals(result.message(), "Error while getting connection stub. gRPC Client connector " +
        "is not initialized properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteSimpleRPCNullConnectionStub(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteSimpleRPCNullMethodName() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteSimpleRPCNullMethodName('client);
    if result is error {
        test:assertEquals(result.message(), "Error while processing the request. RPC endpoint doesn't set properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteSimpleRPCNullMethodName(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteSimpleRPCNullDescriptor() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteSimpleRPCNullDescriptor('client);
    if result is error {
        test:assertEquals(result.message(), "Error while processing the request. " +
        "method descriptors doesn't set properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteSimpleRPCNullDescriptor(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteServerStreamingNullClientEndpoint() returns error? {
    error? result = externInvokeExecuteServerStreamingNullClientEndpoint();
    if result is error {
        test:assertEquals(result.message(), "Error while getting connector. gRPC Client connector " +
        "is not initialized properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteServerStreamingNullClientEndpoint() returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteServerStreamingNullConnectionStub() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteServerStreamingNullConnectionStub('client);
    if result is error {
        test:assertEquals(result.message(), "Error while getting connection stub. gRPC Client connector " +
        "is not initialized properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteServerStreamingNullConnectionStub(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteServerStreamingNullMethodName() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteServerStreamingNullMethodName('client);
    if result is error {
        test:assertEquals(result.message(), "Error while processing the request. RPC endpoint doesn't set properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteServerStreamingNullMethodName(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteServerStreamingNullDescriptor() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteServerStreamingNullDescriptor('client);
    if result is error {
        test:assertEquals(result.message(), "Error while processing the request. method descriptors doesn't set properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteServerStreamingNullDescriptor(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteServerStreamingNullMethodDescriptor() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteServerStreamingNullMethodDescriptor('client);
    if result is error {
        test:assertEquals(result.message(), "No registered method descriptor for 'test'");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteServerStreamingNullMethodDescriptor(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteClientStreamingNullClientEndpoint() returns error? {
    error? result = externInvokeExecuteClientStreamingNullClientEndpoint();
    if result is error {
        test:assertEquals(result.message(), "Error while getting connector. gRPC Client connector " +
        "is not initialized properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteClientStreamingNullClientEndpoint() returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteClientStreamingNullConnectionStub() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteClientStreamingNullConnectionStub('client);
    if result is error {
        test:assertEquals(result.message(), "Error while getting connection stub. gRPC Client connector " +
        "is not initialized properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteClientStreamingNullConnectionStub(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteClientStreamingNullMethodName() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteClientStreamingNullMethodName('client);
    if result is error {
        test:assertEquals(result.message(), "Error while processing the request. RPC endpoint doesn't set properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteClientStreamingNullMethodName(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteClientStreamingNullDescriptor() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteClientStreamingNullDescriptor('client);
    if result is error {
        test:assertEquals(result.message(), "Error while processing the request. method descriptors doesn't set properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteClientStreamingNullDescriptor(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteClientStreamingNullMethodDescriptor() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteClientStreamingNullMethodDescriptor('client);
    if result is error {
        test:assertEquals(result.message(), "No registered method descriptor for 'test'");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteClientStreamingNullMethodDescriptor(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteBidirectionalStreamingNullClientEndpoint() returns error? {
    error? result = externInvokeExecuteBidirectionalStreamingNullClientEndpoint();
    if result is error {
        test:assertEquals(result.message(), "Error while getting connector. gRPC Client connector " +
        "is not initialized properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteBidirectionalStreamingNullClientEndpoint() returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteBidirectionalStreamingNullConnectionStub() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteBidirectionalStreamingNullConnectionStub('client);
    if result is error {
        test:assertEquals(result.message(), "Error while getting connection stub. gRPC Client connector " +
        "is not initialized properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteBidirectionalStreamingNullConnectionStub(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteBidirectionalStreamingNullMethodName() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteBidirectionalStreamingNullMethodName('client);
    if result is error {
        test:assertEquals(result.message(), "Error while processing the request. RPC endpoint doesn't set properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteBidirectionalStreamingNullMethodName(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteBidirectionalStreamingNullDescriptor() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteBidirectionalStreamingNullDescriptor('client);
    if result is error {
        test:assertEquals(result.message(), "Error while processing the request. method descriptors doesn't set properly");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteBidirectionalStreamingNullDescriptor(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternExecuteBidirectionalStreamingNullMethodDescriptor() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeExecuteBidirectionalStreamingNullMethodDescriptor('client);
    if result is error {
        test:assertEquals(result.message(), "No registered method descriptor for 'test'");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeExecuteBidirectionalStreamingNullMethodDescriptor(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testCloseStreamErrorCase() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeCloseStreamErrorCase('client, new TestBObject());
    if result is error {
        test:assertEquals(result.message(), "This is a test error");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeCloseStreamErrorCase(grpc:Client 'client, TestBObject testBObject) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testCloseStreamInvalidErrorCase() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeCloseStreamInvalidErrorCase('client, new TestBObject(), new TestBObject());
    test:assertTrue(result is ());
}

isolated function externInvokeCloseStreamInvalidErrorCase(grpc:Client 'client, TestBObject streamIterator,
TestBObject errorVal) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testGetConnectorError() returns error? {
    boolean|error result = externInvokeGetConnectorError();
    if result is boolean {
        test:assertTrue(result);
    } else {
        test:assertFail("Expected a boolean");
    }
}

isolated function externInvokeGetConnectorError() returns boolean|error =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternCompleteErrorCase() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeCompleteErrorCase('client);
    if result is error {
        test:assertEquals(result.message(), "Error while initializing connector. response sender does not exist");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeCompleteErrorCase(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternSendErrorCase() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeSendErrorCase('client);
    if result is error {
        test:assertEquals(result.message(), "Error while initializing connector. Response sender does not exist");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeSendErrorCase(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternSendErrorErrorCase() returns error? {
    grpc:Client 'client = check new("http://localhost:9090");
    error? result = externInvokeSendErrorErrorCase('client);
    if result is error {
        test:assertEquals(result.message(), "Error while sending the error. Response observer not found.");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeSendErrorErrorCase(grpc:Client 'client) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testExternRegisterErrorCase() returns error? {
    grpc:Service 'service = service object {};
    error? result = externInvokeRegisterErrorCase('service);
    if result is error {
        test:assertEquals(result.message(), "Error when initializing service register builder.");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeRegisterErrorCase(grpc:Service 'service) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testNextResultErrorCase() returns error? {
    error? result = externInvokeNextResultErrorCase(new TestBObject());
    if result is error {
        test:assertEquals(result.message(), "Internal error occurred. The current thread got interrupted");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeNextResultErrorCase(TestBObject streamIterator) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testStreamCompleteCase() returns error? {
    error? result = externInvokeStreamCompleteCase(new TestBObject());
    if result is error {
        test:assertEquals(result.message(), "Error while completing the message. endpoint does not exist");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeStreamCompleteCase(TestBObject streamConnection) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testStreamSendErrorCase() returns error? {
    error? result = externInvokeStreamSendErrorCase(new TestBObject());
    if result is error {
        test:assertEquals(result.message(), "Error while sending the message. endpoint does not exist");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeStreamSendErrorCase(TestBObject streamConnection) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

@test:Config {enable: true}
function testStreamSendErrorErrorCase() returns error? {
    error? result = externInvokeStreamSendErrorErrorCase(new TestBObject());
    if result is error {
        test:assertEquals(result.message(), "Error while sending the error. endpoint does not exist");
    } else {
        test:assertFail("Expected an error");
    }
}

isolated function externInvokeStreamSendErrorErrorCase(TestBObject streamConnection) returns error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.testutils.NativeTestUtils"
} external;

class TestBObject {}
