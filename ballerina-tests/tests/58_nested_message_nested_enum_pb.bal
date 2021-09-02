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

public isolated client class helloWorldWithNestedMessageNestedEnumClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_58_NESTED_MESSAGE_NESTED_ENUM, getDescriptorMap58NestedMessageNestedEnum());
    }

    isolated remote function hello(HelloRequest58|ContextHelloRequest58 req) returns HelloResponse58|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest58 message;
        if req is ContextHelloRequest58 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedMessageNestedEnum/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HelloResponse58>result;
    }

    isolated remote function helloContext(HelloRequest58|ContextHelloRequest58 req) returns ContextHelloResponse58|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest58 message;
        if req is ContextHelloRequest58 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedMessageNestedEnum/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <HelloResponse58>result, headers: respHeaders};
    }

    isolated remote function bye(ByeRequest58|ContextByeRequest58 req) returns ByeResponse58|grpc:Error {
        map<string|string[]> headers = {};
        ByeRequest58 message;
        if req is ContextByeRequest58 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedMessageNestedEnum/bye", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ByeResponse58>result;
    }

    isolated remote function byeContext(ByeRequest58|ContextByeRequest58 req) returns ContextByeResponse58|grpc:Error {
        map<string|string[]> headers = {};
        ByeRequest58 message;
        if req is ContextByeRequest58 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedMessageNestedEnum/bye", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ByeResponse58>result, headers: respHeaders};
    }
}

public client class HelloWorldWithNestedMessageNestedEnumByeResponse58Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendByeResponse58(ByeResponse58 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextByeResponse58(ContextByeResponse58 response) returns grpc:Error? {
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

public client class HelloWorldWithNestedMessageNestedEnumHelloResponse58Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendHelloResponse58(HelloResponse58 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextHelloResponse58(ContextHelloResponse58 response) returns grpc:Error? {
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

public type ContextHelloRequest58 record {|
    HelloRequest58 content;
    map<string|string[]> headers;
|};

public type ContextByeRequest58 record {|
    ByeRequest58 content;
    map<string|string[]> headers;
|};

public type ContextHelloResponse58 record {|
    HelloResponse58 content;
    map<string|string[]> headers;
|};

public type ContextByeResponse58 record {|
    ByeResponse58 content;
    map<string|string[]> headers;
|};

public type FileInfo record {|
    FileInfo_Observability observability = {};
|};

public type FileInfo_Observability record {|
    string id = "";
    string latest_version = "";
    FileInfo_Observability_TraceId traceId = {};
|};

public type FileInfo_Observability_TraceId record {|
    string id = "";
    string latest_version = "";
|};

public type FileType record {|
    FileType_Type 'type = UNKNOWN;
|};

public enum FileType_Type {
    UNKNOWN,
    FILE,
    DIRECTORY
}

public type HelloRequest58 record {|
    string name = "";
|};

public type ByeRequest58 record {|
    FileInfo fileInfo = {};
    priority reqPriority = high;
|};

public type HelloResponse58 record {|
    string message = "";
    HelloResponse58_sentiment mode = happy;
    HelloResponse58_Bar[] bars = [];
|};

public type HelloResponse58_Bar record {|
    int i = 0;
    HelloResponse58_Bar_Foo[] foo = [];
|};

public type HelloResponse58_Bar_Foo record {|
    int i = 0;
|};

public enum HelloResponse58_sentiment {
    happy,
    sad,
    neutral
}

public type ByeResponse58 record {|
    string say = "";
    FileType fileType = {};
|};

public enum priority {
    high,
    medium,
    low
}

const string ROOT_DESCRIPTOR_58_NESTED_MESSAGE_NESTED_ENUM = "0A2335385F6E65737465645F6D6573736167655F6E65737465645F656E756D2E70726F746F22240A0E48656C6C6F52657175657374353812120A046E616D6518012001280952046E616D652289020A0F48656C6C6F526573706F6E7365353812180A076D65737361676518012001280952076D657373616765122E0A046D6F646518022001280E321A2E48656C6C6F526573706F6E736535382E73656E74696D656E7452046D6F646512280A046261727318032003280B32142E48656C6C6F526573706F6E736535382E4261725204626172731A540A03426172120C0A0169180120012805520169122A0A03666F6F18022003280B32182E48656C6C6F526573706F6E736535382E4261722E466F6F5203666F6F1A130A03466F6F120C0A0169180120012805520169222C0A0973656E74696D656E7412090A056861707079100012070A037361641001120B0A076E65757472616C100222620A0C42796552657175657374353812250A0866696C65496E666F18012001280B32092E46696C65496E666F520866696C65496E666F122B0A0B7265715072696F7269747918022001280E32092E7072696F72697479520B7265715072696F7269747922480A0D427965526573706F6E7365353812100A03736179180120012809520373617912250A0866696C655479706518022001280B32092E46696C6554797065520866696C6554797065225C0A0846696C655479706512220A047479706518012001280E320E2E46696C65547970652E54797065520474797065222C0A0454797065120B0A07554E4B4E4F574E100012080A0446494C451001120D0A094449524543544F5259100222A9020A0846696C65496E666F123D0A0D6F62736572766162696C69747918012001280B32172E46696C65496E666F2E4F62736572766162696C697479520D6F62736572766162696C6974791ADD010A0D4F62736572766162696C697479121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E12390A077472616365496418032001280B321F2E46696C65496E666F2E4F62736572766162696C6974792E547261636549645207747261636549641A4D0A0754726163654964121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E2A290A087072696F7269747912080A04686967681000120A0A066D656469756D100112070A036C6F77100232790A2568656C6C6F576F726C64576974684E65737465644D6573736167654E6573746564456E756D122A0A0568656C6C6F120F2E48656C6C6F5265717565737435381A102E48656C6C6F526573706F6E7365353812240A03627965120D2E4279655265717565737435381A0E2E427965526573706F6E73653538620670726F746F33";

public isolated function getDescriptorMap58NestedMessageNestedEnum() returns map<string> {
    return {"58_nested_message_nested_enum.proto": "0A2335385F6E65737465645F6D6573736167655F6E65737465645F656E756D2E70726F746F22240A0E48656C6C6F52657175657374353812120A046E616D6518012001280952046E616D652289020A0F48656C6C6F526573706F6E7365353812180A076D65737361676518012001280952076D657373616765122E0A046D6F646518022001280E321A2E48656C6C6F526573706F6E736535382E73656E74696D656E7452046D6F646512280A046261727318032003280B32142E48656C6C6F526573706F6E736535382E4261725204626172731A540A03426172120C0A0169180120012805520169122A0A03666F6F18022003280B32182E48656C6C6F526573706F6E736535382E4261722E466F6F5203666F6F1A130A03466F6F120C0A0169180120012805520169222C0A0973656E74696D656E7412090A056861707079100012070A037361641001120B0A076E65757472616C100222620A0C42796552657175657374353812250A0866696C65496E666F18012001280B32092E46696C65496E666F520866696C65496E666F122B0A0B7265715072696F7269747918022001280E32092E7072696F72697479520B7265715072696F7269747922480A0D427965526573706F6E7365353812100A03736179180120012809520373617912250A0866696C655479706518022001280B32092E46696C6554797065520866696C6554797065225C0A0846696C655479706512220A047479706518012001280E320E2E46696C65547970652E54797065520474797065222C0A0454797065120B0A07554E4B4E4F574E100012080A0446494C451001120D0A094449524543544F5259100222A9020A0846696C65496E666F123D0A0D6F62736572766162696C69747918012001280B32172E46696C65496E666F2E4F62736572766162696C697479520D6F62736572766162696C6974791ADD010A0D4F62736572766162696C697479121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E12390A077472616365496418032001280B321F2E46696C65496E666F2E4F62736572766162696C6974792E547261636549645207747261636549641A4D0A0754726163654964121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E2A290A087072696F7269747912080A04686967681000120A0A066D656469756D100112070A036C6F77100232790A2568656C6C6F576F726C64576974684E65737465644D6573736167654E6573746564456E756D122A0A0568656C6C6F120F2E48656C6C6F5265717565737435381A102E48656C6C6F526573706F6E7365353812240A03627965120D2E4279655265717565737435381A0E2E427965526573706F6E73653538620670726F746F33"};
}

