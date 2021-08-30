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

public isolated client class HelloWorld31Client {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_31, getDescriptorMap31());
    }

    isolated remote function sayHello(SampleMsg31|ContextSampleMsg31 req) returns (SampleMsg31|Error) {
        map<string|string[]> headers = {};
        SampleMsg31 message;
        if (req is ContextSampleMsg31) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld31/sayHello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SampleMsg31>result;
    }

    isolated remote function sayHelloContext(SampleMsg31|ContextSampleMsg31 req) returns (ContextSampleMsg31|Error) {
        map<string|string[]> headers = {};
        SampleMsg31 message;
        if (req is ContextSampleMsg31) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld31/sayHello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SampleMsg31>result, headers: respHeaders};
    }
}

public client class HelloWorld31SampleMsg31Caller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSampleMsg31(SampleMsg31 response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSampleMsg31(ContextSampleMsg31 response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public type ContextSampleMsg31 record {|
    SampleMsg31 content;
    map<string|string[]> headers;
|};

public type SampleMsg31 record {|
    string name = "";
    int id = 0;
|};

const string ROOT_DESCRIPTOR_31 = "0A1533315F72657475726E5F756E6172792E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22310A0B53616D706C654D7367333112120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432360A0C48656C6C6F576F726C64333112260A0873617948656C6C6F120C2E53616D706C654D736733311A0C2E53616D706C654D73673331620670726F746F33";

isolated function getDescriptorMap31() returns map<string> {
    return {"31_return_unary.proto": "0A1533315F72657475726E5F756E6172792E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22310A0B53616D706C654D7367333112120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432360A0C48656C6C6F576F726C64333112260A0873617948656C6C6F120C2E53616D706C654D736733311A0C2E53616D706C654D73673331620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

