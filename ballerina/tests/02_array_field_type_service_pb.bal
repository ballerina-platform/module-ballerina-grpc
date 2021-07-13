// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
// This is server implementation for bidirectional streaming scenario

public isolated client class HelloWorld3Client {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_2, getDescriptorMap2());
    }

    isolated remote function testIntArrayInput(TestInt|ContextTestInt req) returns (int|Error) {
        map<string|string[]> headers = {};
        TestInt message;
        if (req is ContextTestInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testIntArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function testIntArrayInputContext(TestInt|ContextTestInt req) returns (ContextInt|Error) {
        map<string|string[]> headers = {};
        TestInt message;
        if (req is ContextTestInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testIntArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function testStringArrayInput(TestString|ContextTestString req) returns (string|Error) {
        map<string|string[]> headers = {};
        TestString message;
        if (req is ContextTestString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStringArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function testStringArrayInputContext(TestString|ContextTestString req) returns (ContextString|Error) {
        map<string|string[]> headers = {};
        TestString message;
        if (req is ContextTestString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStringArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testFloatArrayInput(TestFloat|ContextTestFloat req) returns (float|Error) {
        map<string|string[]> headers = {};
        TestFloat message;
        if (req is ContextTestFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testFloatArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <float>result;
    }

    isolated remote function testFloatArrayInputContext(TestFloat|ContextTestFloat req) returns (ContextFloat|Error) {
        map<string|string[]> headers = {};
        TestFloat message;
        if (req is ContextTestFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testFloatArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <float>result, headers: respHeaders};
    }

    isolated remote function testBooleanArrayInput(TestBoolean|ContextTestBoolean req) returns (boolean|Error) {
        map<string|string[]> headers = {};
        TestBoolean message;
        if (req is ContextTestBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testBooleanArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <boolean>result;
    }

    isolated remote function testBooleanArrayInputContext(TestBoolean|ContextTestBoolean req) returns (ContextBoolean|Error) {
        map<string|string[]> headers = {};
        TestBoolean message;
        if (req is ContextTestBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testBooleanArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <boolean>result, headers: respHeaders};
    }

    isolated remote function testStructArrayInput(TestStruct|ContextTestStruct req) returns (string|Error) {
        map<string|string[]> headers = {};
        TestStruct message;
        if (req is ContextTestStruct) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStructArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function testStructArrayInputContext(TestStruct|ContextTestStruct req) returns (ContextString|Error) {
        map<string|string[]> headers = {};
        TestStruct message;
        if (req is ContextTestStruct) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStructArrayInput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testIntArrayOutput() returns (TestInt|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testIntArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <TestInt>result;
    }

    isolated remote function testIntArrayOutputContext() returns (ContextTestInt|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testIntArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <TestInt>result, headers: respHeaders};
    }

    isolated remote function testStringArrayOutput() returns (TestString|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStringArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <TestString>result;
    }

    isolated remote function testStringArrayOutputContext() returns (ContextTestString|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStringArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <TestString>result, headers: respHeaders};
    }

    isolated remote function testFloatArrayOutput() returns (TestFloat|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testFloatArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <TestFloat>result;
    }

    isolated remote function testFloatArrayOutputContext() returns (ContextTestFloat|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testFloatArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <TestFloat>result, headers: respHeaders};
    }

    isolated remote function testBooleanArrayOutput() returns (TestBoolean|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testBooleanArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <TestBoolean>result;
    }

    isolated remote function testBooleanArrayOutputContext() returns (ContextTestBoolean|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testBooleanArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <TestBoolean>result, headers: respHeaders};
    }

    isolated remote function testStructArrayOutput() returns (TestStruct|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStructArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <TestStruct>result;
    }

    isolated remote function testStructArrayOutputContext() returns (ContextTestStruct|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStructArrayOutput", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <TestStruct>result, headers: respHeaders};
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

//public type ContextNil record {|
//    map<string|string[]> headers;
//|};

public type ContextTestInt record {|
    TestInt content;
    map<string|string[]> headers;
|};

public type ContextBoolean record {|
    boolean content;
    map<string|string[]> headers;
|};

//public type ContextString record {|
//    string content;
//    map<string|string[]> headers;
//|};

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

//public type Empty record {|
//|};

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
    return {"02_array_field_type_service.proto": "0A2130325F61727261795F6669656C645F747970655F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22210A0754657374496E7412160A0676616C756573180120032803520676616C75657322240A0A54657374537472696E6712160A0676616C756573180120032809520676616C75657322230A0954657374466C6F617412160A0676616C756573180120032802520676616C75657322250A0B54657374426F6F6C65616E12160A0676616C756573180120032808520676616C75657322350A0A5465737453747275637412270A0676616C75657318012003280B320F2E6772706373657276696365732E41520676616C75657322170A014112120A046E616D6518012001280952046E616D653284060A0B48656C6C6F576F726C643312470A1174657374496E744172726179496E70757412152E6772706373657276696365732E54657374496E741A1B2E676F6F676C652E70726F746F6275662E496E74333256616C7565124E0A1474657374537472696E674172726179496E70757412182E6772706373657276696365732E54657374537472696E671A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565124B0A1374657374466C6F61744172726179496E70757412172E6772706373657276696365732E54657374466C6F61741A1B2E676F6F676C652E70726F746F6275662E466C6F617456616C7565124E0A1574657374426F6F6C65616E4172726179496E70757412192E6772706373657276696365732E54657374426F6F6C65616E1A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565124E0A14746573745374727563744172726179496E70757412182E6772706373657276696365732E546573745374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512430A1274657374496E7441727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A152E6772706373657276696365732E54657374496E7412490A1574657374537472696E6741727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A182E6772706373657276696365732E54657374537472696E6712470A1474657374466C6F617441727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A172E6772706373657276696365732E54657374466C6F6174124B0A1674657374426F6F6C65616E41727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A192E6772706373657276696365732E54657374426F6F6C65616E12490A157465737453747275637441727261794F757470757412162E676F6F676C652E70726F746F6275662E456D7074791A182E6772706373657276696365732E54657374537472756374620670726F746F33", "google/protobuf/empty.proto": "0A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F120F676F6F676C652E70726F746F62756622070A05456D70747942540A13636F6D2E676F6F676C652E70726F746F627566420A456D70747950726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

