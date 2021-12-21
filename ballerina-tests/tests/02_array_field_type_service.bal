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

listener grpc:Listener ep2 = new (9092, {
    host:"localhost"
});

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_02_ARRAY_FIELD_TYPE_SERVICE,
    descMap: getDescriptorMap02ArrayFieldTypeService()
}
service "HelloWorld3" on ep2 {

    isolated remote function testIntArrayInput(HelloWorld3IntCaller caller, TestInt req) {
        int[] numbers = req.values;
        int result = 0;
        foreach var number in numbers {
            result = result + number;
        }
        checkpanic caller->sendInt(result);
        checkpanic caller->complete();
    }

    isolated remote function testStringArrayInput(HelloWorld3StringCaller caller, TestString req) {
        string[] values = req.values;
        string result = "";
        foreach var value in values {
            result = result + "," + value;
        }
        checkpanic caller->sendString(result);
        checkpanic caller->complete();
    }

    isolated remote function testFloatArrayInput(HelloWorld3FloatCaller caller, TestFloat req) {
        float[] values = req.values;
        float result = 0.0;
        foreach var value in values {
            result = result + value;
        }
        grpc:Error? err = caller->sendFloat(result);
        if err is grpc:Error {
            log:printError("Error from Connector: " + err.message());
        }
        checkpanic caller->complete();
    }

    isolated remote function testBooleanArrayInput(HelloWorld3BooleanCaller caller, TestBoolean req) {
        boolean[] values = req.values;
        boolean result = false;
        foreach var value in values {
            result = result || value;
        }
        checkpanic caller->sendBoolean(result);
        checkpanic caller->complete();
    }

    isolated remote function testStructArrayInput(HelloWorld3StringCaller caller, TestStruct req) {
        A[] values = req.values;
        string result = "";
        foreach var value in values {
            result = result + "," + <string> value.name;
        }
        checkpanic caller->sendString(result);
        checkpanic caller->complete();
    }

    isolated remote function testIntArrayOutput(HelloWorld3TestIntCaller caller) {
        TestInt intArray = {values:[1, 2, 3, 4, 5]};
        checkpanic caller->sendTestInt(intArray);
        checkpanic caller->complete();
    }

    isolated remote function testStringArrayOutput(HelloWorld3TestStringCaller caller) {
        TestString stringArray = {values:["A", "B", "C"]};
        grpc:Error? err = caller->sendTestString(stringArray);
        if err is grpc:Error {
            log:printError("Error from Connector: " + err.message());
        }
        checkpanic caller->complete();
    }

    isolated remote function testFloatArrayOutput(HelloWorld3TestFloatCaller caller) {
        TestFloat floatArray = {values:[1.1, 1.2, 1.3, 1.4, 1.5]};
        checkpanic caller->sendTestFloat(floatArray);
        checkpanic caller->complete();
    }

    isolated remote function testBooleanArrayOutput(HelloWorld3TestBooleanCaller caller) {
        TestBoolean booleanArray = {values:[true, false, true]};
        checkpanic caller->sendTestBoolean(booleanArray);
        checkpanic caller->complete();
    }

    isolated remote function testStructArrayOutput(HelloWorld3TestStructCaller caller) {
        A a1 = {name:"Sam"};
        A a2 = {name:"John"};
        TestStruct structArray = {values:[a1, a2]};
        checkpanic caller->sendTestStruct(structArray);
        checkpanic caller->complete();
    }
}
