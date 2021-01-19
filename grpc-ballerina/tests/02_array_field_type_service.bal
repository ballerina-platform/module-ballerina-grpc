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

public client class HelloWorld3FloatCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendFloat(float response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextFloat(ContextFloat response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld3IntCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendInt(int response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextInt(ContextInt response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld3TestFloatCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendTestFloat(TestFloat response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextTestFloat(ContextTestFloat response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld3TestBooleanCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendTestBoolean(TestBoolean response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextTestBoolean(ContextTestBoolean response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld3BooleanCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendBoolean(boolean response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextBoolean(ContextBoolean response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld3TestIntCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendTestInt(TestInt response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextTestInt(ContextTestInt response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld3StringCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendString(string response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextString(ContextString response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld3TestStructCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendTestStruct(TestStruct response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextTestStruct(ContextTestStruct response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld3TestStringCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendTestString(TestString response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextTestString(ContextTestString response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public type ContextTestInt record {|
    TestInt content;
    map<string|string[]> headers;
|};

public type ContextBoolean record {|
    boolean content;
    map<string|string[]> headers;
|};

public type ContextTestBoolean record {|
    TestBoolean content;
    map<string|string[]> headers;
|};

public type ContextTestStruct record {|
    TestStruct content;
    map<string|string[]> headers;
|};

public type ContextFloat record {|
    float content;
    map<string|string[]> headers;
|};

public type ContextTestFloat record {|
    TestFloat content;
    map<string|string[]> headers;
|};

public type ContextInt record {|
    int content;
    map<string|string[]> headers;
|};

public type ContextTestString record {|
    TestString content;
    map<string|string[]> headers;
|};
public type A record {|
    string name = "";

|};

public type TestInt record {|
    int[] values = [];

|};

public type TestBoolean record {|
    boolean[] values = [];

|};


public type TestStruct record {|
    A[] values = [];
|};


public type TestFloat record {|
    float[] values = [];
|};


public type TestString record {|
    string[] values = [];

|};

const string ROOT_DESCRIPTOR_2 = "0A2130325F61727261795F6669656C645F747970655F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22210A0754657374496E7412160A0676616C756573180120032803520676616C75657322240A0A54657374537472696E6712160A0676616C756573180120032809520676616C75657322230A0954657374466C6F617412160A0676616C756573180120032802520676616C75657322250A0B54657374426F6F6C65616E12160A0676616C756573180120032808520676616C75657322350A0A5465737453747275637412270A0676616C75657318012003280B320F2E6772706373657276696365732E41520676616C75657322170A014112120A046E616D6518012001280952046E616D653284060A0B48656C6C6F576F726C643312470A1174657374496E744172726179496E70757412152E6772706373657276696365732E54657374496E741A1B2E676F6F676C652E70726F746F6275662E496E74333256616C7565124E0A1474657374537472696E674172726179496E70757412182E6772706373657276696365732E54657374537472696E671A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565124B0A1374657374466C6F61744172726179496E70757412172E6772706373657276696365732E54657374466C6F61741A1B2E676F6F676C652E70726F746F6275662E466C6F617456616C7565124E0A1574657374426F6F6C65616E4172726179496E70757412192E6772706373657276696365732E54657374426F6F6C65616E1A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565124E0A14746573745374727563744172726179496E70757412182E6772706373657276696365732E546573745374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512430A1274657374496E7441727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A152E6772706373657276696365732E54657374496E7412490A1574657374537472696E6741727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A182E6772706373657276696365732E54657374537472696E6712470A1474657374466C6F617441727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A172E6772706373657276696365732E54657374466C6F6174124B0A1674657374426F6F6C65616E41727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A192E6772706373657276696365732E54657374426F6F6C65616E12490A157465737453747275637441727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A182E6772706373657276696365732E54657374537472756374620670726F746F33";
isolated function getDescriptorMap2() returns map<string> {
    return {
        "02_array_field_type_service.proto":"0A2130325F61727261795F6669656C645F747970655F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22210A0754657374496E7412160A0676616C756573180120032803520676616C75657322240A0A54657374537472696E6712160A0676616C756573180120032809520676616C75657322230A0954657374466C6F617412160A0676616C756573180120032802520676616C75657322250A0B54657374426F6F6C65616E12160A0676616C756573180120032808520676616C75657322350A0A5465737453747275637412270A0676616C75657318012003280B320F2E6772706373657276696365732E41520676616C75657322170A014112120A046E616D6518012001280952046E616D653284060A0B48656C6C6F576F726C643312470A1174657374496E744172726179496E70757412152E6772706373657276696365732E54657374496E741A1B2E676F6F676C652E70726F746F6275662E496E74333256616C7565124E0A1474657374537472696E674172726179496E70757412182E6772706373657276696365732E54657374537472696E671A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565124B0A1374657374466C6F61744172726179496E70757412172E6772706373657276696365732E54657374466C6F61741A1B2E676F6F676C652E70726F746F6275662E466C6F617456616C7565124E0A1574657374426F6F6C65616E4172726179496E70757412192E6772706373657276696365732E54657374426F6F6C65616E1A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565124E0A14746573745374727563744172726179496E70757412182E6772706373657276696365732E546573745374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512430A1274657374496E7441727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A152E6772706373657276696365732E54657374496E7412490A1574657374537472696E6741727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A182E6772706373657276696365732E54657374537472696E6712470A1474657374466C6F617441727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A172E6772706373657276696365732E54657374466C6F6174124B0A1674657374426F6F6C65616E41727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A192E6772706373657276696365732E54657374426F6F6C65616E12490A157465737453747275637441727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A182E6772706373657276696365732E54657374537472756374620670726F746F33",
        "google/protobuf/empty.proto":"0A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F120F676F6F676C652E70726F746F62756622070A05456D70747942760A13636F6D2E676F6F676C652E70726F746F627566420A456D70747950726F746F50015A276769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F656D707479F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C7565427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
