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

public isolated client class EmptyHandlerClient {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_46, getDescriptorMap46());
    }

    isolated remote function unaryWithEmpty() returns (Error?) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("EmptyHandler/unaryWithEmpty", message, headers);
    }

    isolated remote function unaryWithEmptyContext() returns (ContextNil|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("EmptyHandler/unaryWithEmpty", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {headers: respHeaders};
    }

    isolated remote function clientStrWithEmpty() returns (ClientStrWithEmptyStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeClientStreaming("EmptyHandler/clientStrWithEmpty");
        return new ClientStrWithEmptyStreamingClient(sClient);
    }

    isolated remote function serverStrWithEmpty() returns stream<string, Error?>|Error {
        Empty req = {};
        var payload = check self.grpcClient->executeServerStreaming("EmptyHandler/serverStrWithEmpty", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        StringStream outputStream = new StringStream(result);
        return new stream<string, Error?>(outputStream);
    }

    isolated remote function serverStrWithEmptyContext() returns ContextStringStream|Error {
        Empty req = {};
        var payload = check self.grpcClient->executeServerStreaming("EmptyHandler/serverStrWithEmpty", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        StringStream outputStream = new StringStream(result);
        return {content: new stream<string, Error?>(outputStream), headers: headers};
    }
}

public client class ClientStrWithEmptyStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendString(string message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextString(ContextString message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receive() returns Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
        }
    }

    isolated remote function receiveContextNil() returns ContextNil|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

//public class StringStream {
//    private stream<anydata, Error?> anydataStream;
//
//    public isolated function init(stream<anydata, Error?> anydataStream) {
//        self.anydataStream = anydataStream;
//    }
//
//    public isolated function next() returns record {|string value;|}|Error? {
//        var streamValue = self.anydataStream.next();
//        if (streamValue is ()) {
//            return streamValue;
//        } else if (streamValue is Error) {
//            return streamValue;
//        } else {
//            record {|string value;|} nextRecord = {value: <string>streamValue.value};
//            return nextRecord;
//        }
//    }
//
//    public isolated function close() returns Error? {
//        return self.anydataStream.close();
//    }
//}

public client class EmptyHandlerNilCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class EmptyHandlerStringCaller {
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

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

//public type ContextStringStream record {|
//    stream<string, error?> content;
//    map<string|string[]> headers;
//|};
//
//public type ContextNil record {|
//    map<string|string[]> headers;
//|};
//
//public type ContextString record {|
//    string content;
//    map<string|string[]> headers;
//|};
//
//public type Empty record {|
//|};

const string ROOT_DESCRIPTOR_46 = "0A1534365F656D7074795F76616C7565732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F32EC010A0C456D70747948616E646C657212400A0E756E61727957697468456D70747912162E676F6F676C652E70726F746F6275662E456D7074791A162E676F6F676C652E70726F746F6275662E456D707479124C0A1273657276657253747257697468456D70747912162E676F6F676C652E70726F746F6275662E456D7074791A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75653001124C0A12636C69656E7453747257697468456D707479121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A162E676F6F676C652E70726F746F6275662E456D7074792801620670726F746F33";

isolated function getDescriptorMap46() returns map<string> {
    return {"46_empty_values.proto": "0A1534365F656D7074795F76616C7565732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F32EC010A0C456D70747948616E646C657212400A0E756E61727957697468456D70747912162E676F6F676C652E70726F746F6275662E456D7074791A162E676F6F676C652E70726F746F6275662E456D707479124C0A1273657276657253747257697468456D70747912162E676F6F676C652E70726F746F6275662E456D7074791A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75653001124C0A12636C69656E7453747257697468456D707479121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A162E676F6F676C652E70726F746F6275662E456D7074792801620670726F746F33", "google/protobuf/empty.proto": "0A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F120F676F6F676C652E70726F746F62756622070A05456D70747942540A13636F6D2E676F6F676C652E70726F746F627566420A456D70747950726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

