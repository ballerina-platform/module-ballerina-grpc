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

public isolated client class HelloWorld34Client {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_34, getDescriptorMap34());
    }

    isolated remote function sayHello34() returns (SayHello34StreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("HelloWorld34/sayHello34");
        return new SayHello34StreamingClient(sClient);
    }
}

public client class SayHello34StreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSampleMsg34(SampleMsg34 message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextSampleMsg34(ContextSampleMsg34 message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveSampleMsg34() returns SampleMsg34|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <SampleMsg34>payload;
        }
    }

    isolated remote function receiveContextSampleMsg34() returns ContextSampleMsg34|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <SampleMsg34>payload, headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorld34SampleMsg34Caller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSampleMsg34(SampleMsg34 response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSampleMsg34(ContextSampleMsg34 response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public type ContextSampleMsg34Stream record {|
    stream<SampleMsg34, error?> content;
    map<string|string[]> headers;
|};

public type ContextSampleMsg34 record {|
    SampleMsg34 content;
    map<string|string[]> headers;
|};

public type SampleMsg34 record {|
    string name = "";
    int id = 0;
|};

const string ROOT_DESCRIPTOR_34 = "0A2533345F72657475726E5F7265636F72645F626964695F73747265616D696E672E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22310A0B53616D706C654D7367333412120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964323C0A0C48656C6C6F576F726C643334122C0A0A73617948656C6C6F3334120C2E53616D706C654D736733341A0C2E53616D706C654D7367333428013001620670726F746F33";

isolated function getDescriptorMap34() returns map<string> {
    return {"34_return_record_bidi_streaming.proto": "0A2533345F72657475726E5F7265636F72645F626964695F73747265616D696E672E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22310A0B53616D706C654D7367333412120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964323C0A0C48656C6C6F576F726C643334122C0A0A73617948656C6C6F3334120C2E53616D706C654D736733341A0C2E53616D706C654D7367333428013001620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

