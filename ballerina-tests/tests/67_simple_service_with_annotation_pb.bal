// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

public isolated client class SimpleServiceWithAnnotationClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_SIMPLE_SERVICE_WITH_ANNOTATION, getDescriptorMapSimpleServiceWithAnnotation());
    }

    isolated remote function unary(SimpleRequestWithAnnotation|ContextSimpleRequestWithAnnotation req) returns SimpleResponseWithAnnotation|grpc:Error {
        map<string|string[]> headers = {};
        SimpleRequestWithAnnotation message;
        if req is ContextSimpleRequestWithAnnotation {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("SimpleServiceWithAnnotation/unary", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SimpleResponseWithAnnotation>result;
    }

    isolated remote function unaryContext(SimpleRequestWithAnnotation|ContextSimpleRequestWithAnnotation req) returns ContextSimpleResponseWithAnnotation|grpc:Error {
        map<string|string[]> headers = {};
        SimpleRequestWithAnnotation message;
        if req is ContextSimpleRequestWithAnnotation {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("SimpleServiceWithAnnotation/unary", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SimpleResponseWithAnnotation>result, headers: respHeaders};
    }

    isolated remote function clientStreaming() returns ClientStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("SimpleServiceWithAnnotation/clientStreaming");
        return new ClientStreamingStreamingClient(sClient);
    }

    isolated remote function serverStreaming(SimpleRequestWithAnnotation|ContextSimpleRequestWithAnnotation req) returns stream<SimpleResponseWithAnnotation, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        SimpleRequestWithAnnotation message;
        if req is ContextSimpleRequestWithAnnotation {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("SimpleServiceWithAnnotation/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        SimpleResponseWithAnnotationStream outputStream = new SimpleResponseWithAnnotationStream(result);
        return new stream<SimpleResponseWithAnnotation, grpc:Error?>(outputStream);
    }

    isolated remote function serverStreamingContext(SimpleRequestWithAnnotation|ContextSimpleRequestWithAnnotation req) returns ContextSimpleResponseWithAnnotationStream|grpc:Error {
        map<string|string[]> headers = {};
        SimpleRequestWithAnnotation message;
        if req is ContextSimpleRequestWithAnnotation {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("SimpleServiceWithAnnotation/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        SimpleResponseWithAnnotationStream outputStream = new SimpleResponseWithAnnotationStream(result);
        return {content: new stream<SimpleResponseWithAnnotation, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectionalStreaming() returns BidirectionalStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("SimpleServiceWithAnnotation/bidirectionalStreaming");
        return new BidirectionalStreamingStreamingClient(sClient);
    }
}

public client class ClientStreamingStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSimpleRequestWithAnnotation(SimpleRequestWithAnnotation message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextSimpleRequestWithAnnotation(ContextSimpleRequestWithAnnotation message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveSimpleResponseWithAnnotation() returns SimpleResponseWithAnnotation|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <SimpleResponseWithAnnotation>payload;
        }
    }

    isolated remote function receiveContextSimpleResponseWithAnnotation() returns ContextSimpleResponseWithAnnotation|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <SimpleResponseWithAnnotation>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class SimpleResponseWithAnnotationStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|SimpleResponseWithAnnotation value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|SimpleResponseWithAnnotation value;|} nextRecord = {value: <SimpleResponseWithAnnotation>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class BidirectionalStreamingStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSimpleRequestWithAnnotation(SimpleRequestWithAnnotation message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextSimpleRequestWithAnnotation(ContextSimpleRequestWithAnnotation message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveSimpleResponseWithAnnotation() returns SimpleResponseWithAnnotation|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <SimpleResponseWithAnnotation>payload;
        }
    }

    isolated remote function receiveContextSimpleResponseWithAnnotation() returns ContextSimpleResponseWithAnnotation|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <SimpleResponseWithAnnotation>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class SimpleServiceWithAnnotationSimpleResponseWithAnnotationCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSimpleResponseWithAnnotation(SimpleResponseWithAnnotation response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSimpleResponseWithAnnotation(ContextSimpleResponseWithAnnotation response) returns grpc:Error? {
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

public type ContextSimpleRequestWithAnnotationStream record {|
    stream<SimpleRequestWithAnnotation, error?> content;
    map<string|string[]> headers;
|};

public type ContextSimpleResponseWithAnnotationStream record {|
    stream<SimpleResponseWithAnnotation, error?> content;
    map<string|string[]> headers;
|};

public type ContextSimpleRequestWithAnnotation record {|
    SimpleRequestWithAnnotation content;
    map<string|string[]> headers;
|};

public type ContextSimpleResponseWithAnnotation record {|
    SimpleResponseWithAnnotation content;
    map<string|string[]> headers;
|};

const string ROOT_DESCRIPTOR_SIMPLE_SERVICE_WITH_ANNOTATION = "0A2473696D706C655F736572766963655F776974685F616E6E6F746174696F6E2E70726F746F1A2473696D706C655F726571756573745F776974685F616E6E6F746174696F6E2E70726F746F1A2573696D706C655F726573706F6E73655F776974685F616E6E6F746174696F6E2E70726F746F32EA020A1B53696D706C655365727669636557697468416E6E6F746174696F6E12460A05756E617279121C2E53696D706C655265717565737457697468416E6E6F746174696F6E1A1D2E53696D706C65526573706F6E736557697468416E6E6F746174696F6E220012520A0F73657276657253747265616D696E67121C2E53696D706C655265717565737457697468416E6E6F746174696F6E1A1D2E53696D706C65526573706F6E736557697468416E6E6F746174696F6E2200300112520A0F636C69656E7453747265616D696E67121C2E53696D706C655265717565737457697468416E6E6F746174696F6E1A1D2E53696D706C65526573706F6E736557697468416E6E6F746174696F6E22002801125B0A166269646972656374696F6E616C53747265616D696E67121C2E53696D706C655265717565737457697468416E6E6F746174696F6E1A1D2E53696D706C65526573706F6E736557697468416E6E6F746174696F6E22002801300142175A156578616D706C652E636F6D2F6D6573736167657331620670726F746F33";

// Need to remove this.
public isolated function getDescriptorMapSimpleServiceWithAnnotation() returns map<string> {
    return {};
}

