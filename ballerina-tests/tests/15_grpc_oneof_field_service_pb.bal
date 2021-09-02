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

import ballerina/grpc;

public isolated client class OneofFieldServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_15_GRPC_ONEOF_FIELD_SERVICE, getDescriptorMap15GrpcOneofFieldService());
    }

    isolated remote function hello(Request1|ContextRequest1 req) returns Response1|grpc:Error {
        map<string|string[]> headers = {};
        Request1 message;
        if req is ContextRequest1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.OneofFieldService/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Response1>result;
    }

    isolated remote function helloContext(Request1|ContextRequest1 req) returns ContextResponse1|grpc:Error {
        map<string|string[]> headers = {};
        Request1 message;
        if req is ContextRequest1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.OneofFieldService/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Response1>result, headers: respHeaders};
    }

    isolated remote function testOneofField(ZZZ|ContextZZZ req) returns ZZZ|grpc:Error {
        map<string|string[]> headers = {};
        ZZZ message;
        if req is ContextZZZ {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.OneofFieldService/testOneofField", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ZZZ>result;
    }

    isolated remote function testOneofFieldContext(ZZZ|ContextZZZ req) returns ContextZZZ|grpc:Error {
        map<string|string[]> headers = {};
        ZZZ message;
        if req is ContextZZZ {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.OneofFieldService/testOneofField", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ZZZ>result, headers: respHeaders};
    }
}

public client class OneofFieldServiceZZZCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendZZZ(ZZZ response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextZZZ(ContextZZZ response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class OneofFieldServiceResponse1Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendResponse1(Response1 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextResponse1(ContextResponse1 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextRequest1 record {|
    Request1 content;
    map<string|string[]> headers;
|};

public type ContextZZZ record {|
    ZZZ content;
    map<string|string[]> headers;
|};

public type ContextResponse1 record {|
    Response1 content;
    map<string|string[]> headers;
|};

public type AAA record {|
    string aaa = "";
|};

public type Request1 record {|
    int age?;
    Address1 address?;
    boolean married?;
    string first_name?;
    string last_name?;
    string 'version?;
|};

isolated function isValidRequest1(Request1 r) returns boolean {
    int otherCount = 0;
    if !(r?.age is ()) {
        otherCount += 1;
    }
    if !(r?.address is ()) {
        otherCount += 1;
    }
    if !(r?.married is ()) {
        otherCount += 1;
    }
    int nameCount = 0;
    if !(r?.first_name is ()) {
        nameCount += 1;
    }
    if !(r?.last_name is ()) {
        nameCount += 1;
    }
    if !(r?.'version is ()) {
        nameCount += 1;
    }
    if (otherCount > 1 || nameCount > 1) {
        return false;
    }
    return true;
}

isolated function setRequest1_Age(Request1 r, int age) {
    r.age = age;
    _ = r.removeIfHasKey("address");
    _ = r.removeIfHasKey("married");
}

isolated function setRequest1_Address(Request1 r, Address1 address) {
    r.address = address;
    _ = r.removeIfHasKey("age");
    _ = r.removeIfHasKey("married");
}

isolated function setRequest1_Married(Request1 r, boolean married) {
    r.married = married;
    _ = r.removeIfHasKey("age");
    _ = r.removeIfHasKey("address");
}

isolated function setRequest1_FirstName(Request1 r, string first_name) {
    r.first_name = first_name;
    _ = r.removeIfHasKey("last_name");
    _ = r.removeIfHasKey("version");
}

isolated function setRequest1_LastName(Request1 r, string last_name) {
    r.last_name = last_name;
    _ = r.removeIfHasKey("first_name");
    _ = r.removeIfHasKey("version");
}

isolated function setRequest1_Version(Request1 r, string 'version) {
    r.'version = 'version;
    _ = r.removeIfHasKey("first_name");
    _ = r.removeIfHasKey("last_name");
}

public type Address1 record {|
    int house_number?;
    int street_number?;
|};

isolated function isValidAddress1(Address1 r) returns boolean {
    int codeCount = 0;
    if !(r?.house_number is ()) {
        codeCount += 1;
    }
    if !(r?.street_number is ()) {
        codeCount += 1;
    }
    if (codeCount > 1) {
        return false;
    }
    return true;
}

isolated function setAddress1_HouseNumber(Address1 r, int house_number) {
    r.house_number = house_number;
    _ = r.removeIfHasKey("street_number");
}

isolated function setAddress1_StreetNumber(Address1 r, int street_number) {
    r.street_number = street_number;
    _ = r.removeIfHasKey("house_number");
}

public type ZZZ record {|
    float aa = 0.0;
    float bb = 0.0;
    int cc = 0;
    int dd = 0;
    int ee = 0;
    int ff = 0;
    int gg = 0;
    boolean hh = false;
    string ii = "";
    AAA jj = {};
    byte[] kk = [];
    float one_a?;
    float one_b?;
    int one_c?;
    int one_d?;
    int one_e?;
    int one_f?;
    int one_g?;
    boolean one_h?;
    string one_i?;
    AAA one_j?;
    byte[] one_k?;
|};

isolated function isValidZzz(ZZZ r) returns boolean {
    int valueCount = 0;
    if !(r?.one_a is ()) {
        valueCount += 1;
    }
    if !(r?.one_b is ()) {
        valueCount += 1;
    }
    if !(r?.one_c is ()) {
        valueCount += 1;
    }
    if !(r?.one_d is ()) {
        valueCount += 1;
    }
    if !(r?.one_e is ()) {
        valueCount += 1;
    }
    if !(r?.one_f is ()) {
        valueCount += 1;
    }
    if !(r?.one_g is ()) {
        valueCount += 1;
    }
    if !(r?.one_h is ()) {
        valueCount += 1;
    }
    if !(r?.one_i is ()) {
        valueCount += 1;
    }
    if !(r?.one_j is ()) {
        valueCount += 1;
    }
    if !(r?.one_k is ()) {
        valueCount += 1;
    }
    if (valueCount > 1) {
        return false;
    }
    return true;
}

isolated function setZZZ_OneA(ZZZ r, float one_a) {
    r.one_a = one_a;
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_j");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneB(ZZZ r, float one_b) {
    r.one_b = one_b;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_j");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneC(ZZZ r, int one_c) {
    r.one_c = one_c;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_j");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneD(ZZZ r, int one_d) {
    r.one_d = one_d;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_j");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneE(ZZZ r, int one_e) {
    r.one_e = one_e;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_j");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneF(ZZZ r, int one_f) {
    r.one_f = one_f;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_j");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneG(ZZZ r, int one_g) {
    r.one_g = one_g;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_j");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneH(ZZZ r, boolean one_h) {
    r.one_h = one_h;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_j");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneI(ZZZ r, string one_i) {
    r.one_i = one_i;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_j");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneJ(ZZZ r, AAA one_j) {
    r.one_j = one_j;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_k");
}

isolated function setZZZ_OneK(ZZZ r, byte[] one_k) {
    r.one_k = one_k;
    _ = r.removeIfHasKey("one_a");
    _ = r.removeIfHasKey("one_b");
    _ = r.removeIfHasKey("one_c");
    _ = r.removeIfHasKey("one_d");
    _ = r.removeIfHasKey("one_e");
    _ = r.removeIfHasKey("one_f");
    _ = r.removeIfHasKey("one_g");
    _ = r.removeIfHasKey("one_h");
    _ = r.removeIfHasKey("one_i");
    _ = r.removeIfHasKey("one_j");
}

public type Response1 record {|
    string message = "";
|};

const string ROOT_DESCRIPTOR_15_GRPC_ONEOF_FIELD_SERVICE = "0A2131355F677270635F6F6E656F665F6669656C645F736572766963652E70726F746F120C67727063736572766963657322DB010A085265717565737431121F0A0A66697273745F6E616D651801200128094800520966697273744E616D65121D0A096C6173745F6E616D65180220012809480052086C6173744E616D65121A0A0776657273696F6E1803200128094800520776657273696F6E12120A036167651804200128054801520361676512320A076164647265737318052001280B32162E6772706373657276696365732E41646472657373314801520761646472657373121A0A076D617272696564180620012808480152076D61727269656442060A046E616D6542070A056F74686572225E0A08416464726573733112230A0C686F7573655F6E756D6265721801200128034800520B686F7573654E756D62657212250A0D7374726565745F6E756D6265721802200128074800520C7374726565744E756D62657242060A04636F646522250A09526573706F6E73653112180A076D65737361676518012001280952076D65737361676522E1030A035A5A5A12150A056F6E655F61180120012801480052046F6E654112150A056F6E655F62180220012802480052046F6E654212150A056F6E655F63180320012803480052046F6E654312150A056F6E655F64180420012804480052046F6E654412150A056F6E655F65180520012805480052046F6E654512150A056F6E655F66180620012806480052046F6E654612150A056F6E655F67180720012807480052046F6E654712150A056F6E655F68180820012808480052046F6E654812150A056F6E655F69180920012809480052046F6E654912280A056F6E655F6A180A2001280B32112E6772706373657276696365732E414141480052046F6E654A12150A056F6E655F6B180B2001280C480052046F6E654B120E0A026161180C2001280152026161120E0A026262180D2001280252026262120E0A026363180E2001280352026363120E0A026464180F2001280452026464120E0A02656518102001280552026565120E0A02666618112001280652026666120E0A02676718122001280752026767120E0A02686818132001280852026868120E0A0269691814200128095202696912210A026A6A18152001280B32112E6772706373657276696365732E41414152026A6A120E0A026B6B18162001280C52026B6B42070A0576616C756522170A0341414112100A0361616118012001280952036161613285010A114F6E656F664669656C645365727669636512380A0568656C6C6F12162E6772706373657276696365732E52657175657374311A172E6772706373657276696365732E526573706F6E73653112360A0E746573744F6E656F664669656C6412112E6772706373657276696365732E5A5A5A1A112E6772706373657276696365732E5A5A5A620670726F746F33";

public isolated function getDescriptorMap15GrpcOneofFieldService() returns map<string> {
    return {"15_grpc_oneof_field_service.proto": "0A2131355F677270635F6F6E656F665F6669656C645F736572766963652E70726F746F120C67727063736572766963657322DB010A085265717565737431121F0A0A66697273745F6E616D651801200128094800520966697273744E616D65121D0A096C6173745F6E616D65180220012809480052086C6173744E616D65121A0A0776657273696F6E1803200128094800520776657273696F6E12120A036167651804200128054801520361676512320A076164647265737318052001280B32162E6772706373657276696365732E41646472657373314801520761646472657373121A0A076D617272696564180620012808480152076D61727269656442060A046E616D6542070A056F74686572225E0A08416464726573733112230A0C686F7573655F6E756D6265721801200128034800520B686F7573654E756D62657212250A0D7374726565745F6E756D6265721802200128074800520C7374726565744E756D62657242060A04636F646522250A09526573706F6E73653112180A076D65737361676518012001280952076D65737361676522E1030A035A5A5A12150A056F6E655F61180120012801480052046F6E654112150A056F6E655F62180220012802480052046F6E654212150A056F6E655F63180320012803480052046F6E654312150A056F6E655F64180420012804480052046F6E654412150A056F6E655F65180520012805480052046F6E654512150A056F6E655F66180620012806480052046F6E654612150A056F6E655F67180720012807480052046F6E654712150A056F6E655F68180820012808480052046F6E654812150A056F6E655F69180920012809480052046F6E654912280A056F6E655F6A180A2001280B32112E6772706373657276696365732E414141480052046F6E654A12150A056F6E655F6B180B2001280C480052046F6E654B120E0A026161180C2001280152026161120E0A026262180D2001280252026262120E0A026363180E2001280352026363120E0A026464180F2001280452026464120E0A02656518102001280552026565120E0A02666618112001280652026666120E0A02676718122001280752026767120E0A02686818132001280852026868120E0A0269691814200128095202696912210A026A6A18152001280B32112E6772706373657276696365732E41414152026A6A120E0A026B6B18162001280C52026B6B42070A0576616C756522170A0341414112100A0361616118012001280952036161613285010A114F6E656F664669656C645365727669636512380A0568656C6C6F12162E6772706373657276696365732E52657175657374311A172E6772706373657276696365732E526573706F6E73653112360A0E746573744F6E656F664669656C6412112E6772706373657276696365732E5A5A5A1A112E6772706373657276696365732E5A5A5A620670726F746F33"};
}

