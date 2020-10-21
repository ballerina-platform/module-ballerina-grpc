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

import ballerina/io;
import ballerina/test;

final HelloWorld7BlockingClient helloWorld7BlockingEp = new ("http://localhost:9097");

//type ResponseTypedesc typedesc<Response>;

@test:Config {}
isolated function testUnaryBlockingClient() {
    string name = "WSO2";
    [string, Headers]|Error unionResp = helloWorld7BlockingEp->hello(name);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client Got Response : ");
        string result = "";
        [result, _] = unionResp;
        io:println(result);
        test:assertEquals(result, "Hello WSO2");
    }
}

@test:Config {}
isolated function testUnaryBlockingIntClient() {
    int age = 10;
    [int, Headers]|Error unionResp = helloWorld7BlockingEp->testInt(age);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client got response : ");
        int result = 0;
        [result, _] = unionResp;
        io:println(result);
        test:assertEquals(result, 8);
    }
}

@test:Config {}
isolated function testUnaryBlockingFloatClient() {
    float salary = 1000.5;
    [float, Headers]|Error unionResp = helloWorld7BlockingEp->testFloat(salary);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client got response : ");
        float result = 0.0;
        [result, _] = unionResp;
        io:println(result);
        test:assertEquals(result, 880.44);
    }
}

@test:Config {}
isolated function testUnaryBlockingBoolClient() {
    boolean isAvailable = false;
    [boolean, Headers]|Error unionResp = helloWorld7BlockingEp->testBoolean(isAvailable);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client got response : ");
        boolean result = false;
        [result, _] = unionResp;
        io:println(result);
        test:assertTrue(result);
    }
}

@test:Config {}
isolated function testUnaryBlockingReceiveRecord() {
    string msg = "WSO2";
    [Response, Headers]|Error unionResp = helloWorld7BlockingEp->testResponseInsideMatch(msg);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client got response : ");
        Response result = {};
        [result, _] = unionResp;
        io:println(result);
        test:assertEquals(result.resp, "Acknowledge WSO2");
    }
}

@test:Config {}
isolated function testUnaryBlockingStructClient() {
    Request req = {name:"Sam", age:10, message:"Testing."};
    [Response, Headers]|Error unionResp = helloWorld7BlockingEp->testStruct(req);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client got response : ");
        Response result = {};
        [result, _] = unionResp;
        io:println(result);
        test:assertEquals(result.resp, "Acknowledge Sam");
    }
}

public client class HelloWorld7BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_7, getDescriptorMap7());
    }

    public isolated remote function hello(string req, Headers? headers = ()) returns ([string, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld100/hello", req, headers);
        any result = ();
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        return [result.toString(), resHeaders];
    }

    public isolated remote function testInt(int req, Headers? headers = ()) returns ([int, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld100/testInt", req, headers);
        anydata result = ();
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        var value = result.cloneWithType(IntTypedesc);
        if (value is int) {
            return [value, resHeaders];
        } else {
            return InternalError("Error while constructing the message", value);
        }
    }

    public isolated remote function testFloat(float req, Headers? headers = ()) returns ([float, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld100/testFloat", req, headers);
        anydata result = ();
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        var value = result.cloneWithType(FloatTypedesc);
        if (value is float) {
            return [value, resHeaders];
        } else {
            return InternalError("Error while constructing the message", value);
        }
    }

    public isolated remote function testBoolean(boolean req, Headers? headers = ()) returns ([boolean, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld100/testBoolean", req, headers);
        anydata result = ();
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        var value = result.cloneWithType(BooleanTypedesc);
        if (value is boolean) {
            return [value, resHeaders];
        } else {
            return InternalError("Error while constructing the message", value);
        }
    }

    public isolated remote function testStruct(Request req, Headers? headers = ()) returns ([Response, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld100/testStruct", req, headers);
        anydata result = ();
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        var value = result.cloneWithType(ResponseTypedesc);
        if (value is Response) {
            return [value, resHeaders];
        } else {
            return InternalError("Error while constructing the message", value);
        }
    }

    public isolated remote function testResponseInsideMatch(string req, Headers? headers = ()) returns [Response, Headers]|Error {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld100/testResponseInsideMatch", req, headers);
        anydata result = ();
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        var value = result.cloneWithType(ResponseTypedesc);
        if (value is Response) {
            return [value, resHeaders];
        } else {
            return InternalError("Error while constructing the message", value);
        }
    }
}
