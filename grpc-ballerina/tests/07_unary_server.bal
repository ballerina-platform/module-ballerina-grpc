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

listener Listener ep7 = new (9097);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_7,
    descMap: getDescriptorMap7()
}
service "HelloWorld100" on ep7 {
    isolated remote function hello(HelloWorld100StringCaller caller, string name) {
        io:println("name: " + name);
        string message = "Hello " + name;
        Error? err = ();
        if (name == "invalid") {
            err = caller->sendError(error AbortedError("Operation aborted"));
        } else {
            err = caller->sendString(message);
        }
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        }
        checkpanic caller->complete();
    }

    isolated remote function testInt(HelloWorld100IntCaller caller, int age) {
        io:println("age: " + age.toString());
        int displayAge = age - 2;
        Error? err = caller->sendInt(displayAge);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("display age : " + displayAge.toString());
        }
        checkpanic caller->complete();
    }

    isolated remote function testFloat(HelloWorld100FloatCaller caller, float salary) {
        io:println("gross salary: " + salary.toString());
        float netSalary = salary * 0.88;
        Error? err = caller->sendFloat(netSalary);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("net salary : " + netSalary.toString());
        }
        checkpanic caller->complete();
    }

    isolated remote function testBoolean(HelloWorld100BooleanCaller caller, boolean available) {
        io:println("is available: " + available.toString());
        boolean aval = available || true;
        Error? err = caller->sendBoolean(aval);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("avaliability : " + aval.toString());
        }
        checkpanic caller->complete();
    }

    isolated remote function testStruct(HelloWorld100ResponseCaller caller, Request msg) {
        io:println(msg.name + " : " + msg.message);
        Response response = {resp:"Acknowledge " + msg.name};
        Error? err = caller->sendResponse(response);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("msg : " + response.resp);
        }
        checkpanic caller->complete();
    }

    isolated remote function testNoRequest(HelloWorld100StringCaller caller) {
        string resp = "service invoked with no request";
        Error? err = caller->sendString(resp);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("response : " + resp);
        }
        checkpanic caller->complete();
    }

    isolated remote function testNoResponse(HelloWorld100NilCaller caller, string msg) {
        io:println("Request: " + msg);
    }

    isolated remote function testResponseInsideMatch(HelloWorld100ResponseCaller caller, string msg) {
        io:println("Request: " + msg);
        Response? res = {resp:"Acknowledge " + msg};
        if (res is Response) {
            checkpanic caller->sendResponse(res);
        } else {
            checkpanic caller->sendError(error NotFoundError("No updates from that drone"));
        }
        checkpanic caller->complete();
    }
}
