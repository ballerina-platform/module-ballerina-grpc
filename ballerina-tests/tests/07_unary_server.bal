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
    isolated remote function hello(HelloWorld100StringCaller caller, string name) returns grpc:Error? {
        string message = "Hello " + name;
        if name == "invalid" {
            check caller->sendError(error grpc:AbortedError("Operation aborted"));
        } else {
            check caller->sendString(message);
        }
        check caller->complete();
    }

    isolated remote function testInt(HelloWorld100IntCaller caller, int age) returns grpc:Error? {
        int displayAge = age - 2;
        check caller->sendInt(displayAge);
        check caller->complete();
    }

    isolated remote function testFloat(HelloWorld100FloatCaller caller, float salary) returns grpc:Error? {
        float netSalary = salary * 0.88;
        check caller->sendFloat(netSalary);
        check caller->complete();
    }

    isolated remote function testBoolean(HelloWorld100BooleanCaller caller, boolean available) returns grpc:Error? {
        boolean aval = available || true;
        check caller->sendBoolean(aval);
        check caller->complete();
    }

    isolated remote function testStruct(HelloWorld100ResponseCaller caller, Request msg) returns grpc:Error? {
        Response response = {resp: "Acknowledge " + msg.name};
        check caller->sendResponse(response);
        check caller->complete();
    }

    isolated remote function testNoRequest(HelloWorld100StringCaller caller) returns grpc:Error? {
        string resp = "service invoked with no request";
        check caller->sendString(resp);
        check caller->complete();
    }

    isolated remote function testNoResponse(HelloWorld100NilCaller caller, string msg) returns grpc:Error? {
        log:printInfo("Request: " + msg);
    }

    isolated remote function testResponseInsideMatch(HelloWorld100ResponseCaller caller, string msg) returns grpc:Error? {
        Response? res = {resp: "Acknowledge " + msg};
        if res is Response {
            check caller->sendResponse(res);
        } else {
            check caller->sendError(error grpc:NotFoundError("No updates from that drone"));
        }
        check caller->complete();
    }
}
