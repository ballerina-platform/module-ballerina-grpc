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

public isolated client class HeadersServiceClient {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_45, getDescriptorMap45());
    }

    isolated remote function unary(HSReq|ContextHSReq req) returns (HSRes|Error) {
        map<string|string[]> headers = {};
        HSReq message;
        if (req is ContextHSReq) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HeadersService/unary", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HSRes>result;
    }

    isolated remote function unaryContext(HSReq|ContextHSReq req) returns (ContextHSRes|Error) {
        map<string|string[]> headers = {};
        HSReq message;
        if (req is ContextHSReq) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HeadersService/unary", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <HSRes>result, headers: respHeaders};
    }

    isolated remote function clientStr() returns (ClientStrStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeClientStreaming("HeadersService/clientStr");
        return new ClientStrStreamingClient(sClient);
    }

    isolated remote function serverStr(HSReq req) returns stream<HSRes, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("HeadersService/serverStr", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        HSResStream outputStream = new HSResStream(result);
        return new stream<HSRes, Error?>(outputStream);
    }

    isolated remote function serverStrContext(HSReq|ContextHSReq req) returns ContextHSResStream|Error {
        map<string|string[]> headers = {};
        HSReq message;
        if (req is ContextHSReq) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("HeadersService/serverStr", message, headers);
        [stream<anydata, Error?>, map<string|string[]>] [result, respHeaders] = payload;
        HSResStream outputStream = new HSResStream(result);
        return {content: new stream<HSRes, Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectionalStr() returns (BidirectionalStrStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("HeadersService/bidirectionalStr");
        return new BidirectionalStrStreamingClient(sClient);
    }
}

public client class ClientStrStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendHSReq(HSReq message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextHSReq(ContextHSReq message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveHSRes() returns HSRes|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <HSRes>payload;
        }
    }

    isolated remote function receiveContextHSRes() returns ContextHSRes|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <HSRes>payload, headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public class HSResStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|HSRes value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|HSRes value;|} nextRecord = {value: <HSRes>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public client class BidirectionalStrStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendHSReq(HSReq message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextHSReq(ContextHSReq message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveHSRes() returns HSRes|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <HSRes>payload;
        }
    }

    isolated remote function receiveContextHSRes() returns ContextHSRes|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <HSRes>payload, headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class HeadersServiceHSResCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendHSRes(HSRes response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextHSRes(ContextHSRes response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public type ContextHSResStream record {|
    stream<HSRes, error?> content;
    map<string|string[]> headers;
|};

public type ContextHSRes record {|
    HSRes content;
    map<string|string[]> headers;
|};

public type ContextHSReqStream record {|
    stream<HSReq, error?> content;
    map<string|string[]> headers;
|};

public type ContextHSReq record {|
    HSReq content;
    map<string|string[]> headers;
|};

public type HSRes record {|
    string name = "";
    string message = "";
|};

public type HSReq record {|
    string name = "";
    string message = "";
|};

const string ROOT_DESCRIPTOR_45 = "0A1E34355F73657276696365735F776974685F686561646572732E70726F746F22350A05485352657112120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D65737361676522350A05485352657312120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765328F010A0E486561646572735365727669636512170A05756E61727912062E48535265711A062E4853526573121D0A0973657276657253747212062E48535265711A062E48535265733001121D0A09636C69656E7453747212062E48535265711A062E4853526573280112260A106269646972656374696F6E616C53747212062E48535265711A062E485352657328013001620670726F746F33";

isolated function getDescriptorMap45() returns map<string> {
    return {"45_services_with_headers.proto": "0A1E34355F73657276696365735F776974685F686561646572732E70726F746F22350A05485352657112120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D65737361676522350A05485352657312120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765328F010A0E486561646572735365727669636512170A05756E61727912062E48535265711A062E4853526573121D0A0973657276657253747212062E48535265711A062E48535265733001121D0A09636C69656E7453747212062E48535265711A062E4853526573280112260A106269646972656374696F6E616C53747212062E48535265711A062E485352657328013001620670726F746F33"};
}
