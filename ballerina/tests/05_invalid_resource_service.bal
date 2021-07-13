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

import ballerina/log;

listener Listener ep5 = new (9095);
@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_5,
    descMap: getDescriptorMap5()
}
service "HelloWorld98" on ep5 {
    isolated remote function hello(HelloWorld98StringCaller caller, string name) {
        log:printInfo("name: " + name);
        string message = "Hello " + name;
        Error? err = ();
        if (name == "invalid") {
            err = caller->sendError(error AbortedError("Operation aborted"));
        } else {
            err = caller->sendString(message);
        }
        if (err is Error) {
            log:printError(err.message(), 'error = err);
        }
        checkpanic caller->complete();
    }

    isolated remote function testInt(HelloWorld98IntCaller caller, string age) {
        log:printInfo("age: " + age);
        int displayAge = 0;
        if (age == "") {
            displayAge = -1;
        } else {
            displayAge = 1;
        }
        Error? err = caller->sendInt(displayAge);
        if (err is Error) {
            log:printError(err.message(), 'error = err);
        } else {
            log:printInfo("display age : " + displayAge.toString());
        }
        checkpanic caller->complete();
    }
}
