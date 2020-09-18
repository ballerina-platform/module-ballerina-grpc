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

HelloWorld5BlockingClient helloWorld5BlockingEp = new ("http://localhost:9095");

@test:Config {}
function testInvalidRemoteMethod() {
    string name = "WSO2";
    [string, Headers]|Error unionResp = helloWorld5BlockingEp->hello(name);
    if (unionResp is Error) {
        test:assertEquals(unionResp.message(), "No registered method descriptor for " +
                                                               "'grpcservices.HelloWorld98/hello1'");
    } else {
        io:println("Client Got Response : ");
        string result = "";
        [result, _] = unionResp;
        io:println(result);
        test:assertFail("Client got response: " + result);
    }
}

@test:Config {}
function testInvalidInputParameter() {
    int age = 10;
    [int, Headers]|Error unionResp = helloWorld5BlockingEp->testInt(age);
    if (unionResp is Error) {
        test:assertFail(io:sprintf("Error from Connector: %s", unionResp.message()));
    } else {
        io:println("Client got response : ");
        int result = 0;
        [result, _] = unionResp;
        test:assertEquals(result, -1);
    }
}

@test:Config {}
function testInvalidOutputResponse() {
    float salary = 1000.5;
    [float, Headers]|Error unionResp = helloWorld5BlockingEp->testFloat(salary);
    if (unionResp is Error) {
        test:assertEquals(unionResp.message(), "Error while constructing the message");
    } else {
        io:println("Client got response : ");
        float result = 0.0;
        [result, _] = unionResp;
        io:println(result);
        test:assertFail(result.toString());
    }
}

public client class HelloWorld5BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_5, getDescriptorMap5());
    }

    public isolated remote function hello(string req, Headers? headers = ()) returns ([string, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld98/hello1", req, headers);
        anydata result = ();
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        return [result.toString(), resHeaders];
    }

    public isolated remote function testInt(int req, Headers? headers = ()) returns ([int, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld98/testInt", req, headers);
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
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld98/testFloat", req, headers);
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
}
