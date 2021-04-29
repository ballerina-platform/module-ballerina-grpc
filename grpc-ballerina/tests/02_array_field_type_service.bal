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

listener Listener ep2 = new (9092, {
    host:"localhost"
});

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_2,
    descMap: getDescriptorMap2()
}
service "HelloWorld3" on ep2 {

    isolated remote function testIntArrayInput(HelloWorld3IntCaller caller, TestInt req) {
        io:println(req);
        int[] numbers = req.values;
        int result = 0;
        foreach var number in numbers {
            result = result + number;
        }
        Error? err = caller->sendInt(result);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("Result: " + result.toString());
        }
        checkpanic caller->complete();
    }

    isolated remote function testStringArrayInput(HelloWorld3StringCaller caller, TestString req) {
        io:println(req);
        string[] values = req.values;
        string result = "";
        foreach var value in values {
            result = result + "," + value;
        }
        Error? err = caller->sendString(result);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("Result: " + result);
        }
        checkpanic caller->complete();
    }

    isolated remote function testFloatArrayInput(HelloWorld3FloatCaller caller, TestFloat req) {
        io:println(req);
        float[] values = req.values;
        float result = 0.0;
        foreach var value in values {
            result = result + value;
        }
        Error? err = caller->sendFloat(result);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("Result: " + result.toString());
        }
        checkpanic caller->complete();
    }

    isolated remote function testBooleanArrayInput(HelloWorld3BooleanCaller caller, TestBoolean req) {
        io:println(req);
        boolean[] values = req.values;
        boolean result = false;
        foreach var value in values {
            result = result || value;
        }
        Error? err = caller->sendBoolean(result);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("Result: " + result.toString());
        }
        checkpanic caller->complete();
    }

    isolated remote function testStructArrayInput(HelloWorld3StringCaller caller, TestStruct req) {
        io:println(req);
        A[] values = req.values;
        string result = "";
        foreach var value in values {
            result = result + "," + <string> value.name;
        }
        Error? err = caller->sendString(result);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("Result: " + result);
        }
        checkpanic caller->complete();
    }

    isolated remote function testIntArrayOutput(HelloWorld3TestIntCaller caller) {
        TestInt intArray = {values:[1, 2, 3, 4, 5]};
        Error? err = caller->sendTestInt(intArray);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println(intArray);
        }
        checkpanic caller->complete();
    }

    isolated remote function testStringArrayOutput(HelloWorld3TestStringCaller caller) {
        TestString stringArray = {values:["A", "B", "C"]};
        Error? err = caller->sendTestString(stringArray);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println(stringArray);
        }
        checkpanic caller->complete();
    }

    isolated remote function testFloatArrayOutput(HelloWorld3TestFloatCaller caller) {
        TestFloat floatArray = {values:[1.1, 1.2, 1.3, 1.4, 1.5]};
        Error? err = caller->sendTestFloat(floatArray);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println(floatArray);
        }
        checkpanic caller->complete();
    }

    isolated remote function testBooleanArrayOutput(HelloWorld3TestBooleanCaller caller) {
        TestBoolean booleanArray = {values:[true, false, true]};
        Error? err = caller->sendTestBoolean(booleanArray);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println(booleanArray);
        }
        checkpanic caller->complete();
    }

    isolated remote function testStructArrayOutput(HelloWorld3TestStructCaller caller) {
        A a1 = {name:"Sam"};
        A a2 = {name:"John"};
        TestStruct structArray = {values:[a1, a2]};
        Error? err = caller->sendTestStruct(structArray);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println(structArray);
        }
        checkpanic caller->complete();
    }
}
