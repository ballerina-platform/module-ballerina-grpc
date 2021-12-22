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

import ballerina/grpc;
import ballerina/log;

listener grpc:Listener ep7 = new (9097);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_07_UNARY_SERVER,
    descMap: getDescriptorMap07UnaryServer()
}
service "HelloWorld100" on ep7 {
    isolated remote function hello(HelloWorld100StringCaller caller, string name) {
        string message = "Hello " + name;
        if name == "invalid" {
            checkpanic caller->sendError(error grpc:AbortedError("Operation aborted"));
        } else {
            checkpanic caller->sendString(message);
        }
        checkpanic caller->complete();
    }

    isolated remote function testInt(HelloWorld100IntCaller caller, int age) {
        int displayAge = age - 2;
        checkpanic caller->sendInt(displayAge);
        checkpanic caller->complete();
    }

    isolated remote function testFloat(HelloWorld100FloatCaller caller, float salary) {
        float netSalary = salary * 0.88;
        checkpanic caller->sendFloat(netSalary);
        checkpanic caller->complete();
    }

    isolated remote function testBoolean(HelloWorld100BooleanCaller caller, boolean available) {
        boolean aval = available || true;
        checkpanic caller->sendBoolean(aval);
        checkpanic caller->complete();
    }

    isolated remote function testStruct(HelloWorld100ResponseCaller caller, Request msg) {
        Response response = {resp: "Acknowledge " + msg.name};
        checkpanic caller->sendResponse(response);
        checkpanic caller->complete();
    }

    isolated remote function testNoRequest(HelloWorld100StringCaller caller) {
        string resp = "service invoked with no request";
        checkpanic caller->sendString(resp);
        checkpanic caller->complete();
    }

    isolated remote function testNoResponse(HelloWorld100NilCaller caller, string msg) {
        log:printInfo("Request: " + msg);
    }

    isolated remote function testResponseInsideMatch(HelloWorld100ResponseCaller caller, string msg) {
        Response? res = {resp: "Acknowledge " + msg};
        if res is Response {
            checkpanic caller->sendResponse(res);
        } else {
            checkpanic caller->sendError(error grpc:NotFoundError("No updates from that drone"));
        }
        checkpanic caller->complete();
    }
}
