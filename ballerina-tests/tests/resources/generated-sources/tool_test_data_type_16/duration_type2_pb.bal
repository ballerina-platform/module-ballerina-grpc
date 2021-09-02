import ballerina/grpc;
import ballerina/time;
import ballerina/protobuf.types.duration;
import ballerina/grpc.types.duration as sduration;

public isolated client class DurationHandlerClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_DURATION_TYPE2, getDescriptorMapDurationType2());
    }

    isolated remote function unaryCall(time:Seconds|duration:ContextDuration req) returns time:Seconds|grpc:Error {
        map<string|string[]> headers = {};
        time:Seconds message;
        if req is duration:ContextDuration {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("DurationHandler/unaryCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <time:Seconds>result;
    }

    isolated remote function unaryCallContext(time:Seconds|duration:ContextDuration req) returns duration:ContextDuration|grpc:Error {
        map<string|string[]> headers = {};
        time:Seconds message;
        if req is duration:ContextDuration {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("DurationHandler/unaryCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <time:Seconds>result, headers: respHeaders};
    }

    isolated remote function clientStreaming() returns ClientStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("DurationHandler/clientStreaming");
        return new ClientStreamingStreamingClient(sClient);
    }

    isolated remote function serverStreaming(time:Seconds|duration:ContextDuration req) returns stream<time:Seconds, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        time:Seconds message;
        if req is duration:ContextDuration {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DurationHandler/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        sduration:DurationStream outputStream = new sduration:DurationStream(result);
        return new stream<time:Seconds, grpc:Error?>(outputStream);
    }

    isolated remote function serverStreamingContext(time:Seconds|duration:ContextDuration req) returns duration:ContextDurationStream|grpc:Error {
        map<string|string[]> headers = {};
        time:Seconds message;
        if req is duration:ContextDuration {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DurationHandler/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        sduration:DurationStream outputStream = new sduration:DurationStream(result);
        return {content: new stream<time:Seconds, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectionalStreaming() returns BidirectionalStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("DurationHandler/bidirectionalStreaming");
        return new BidirectionalStreamingStreamingClient(sClient);
    }
}

public client class ClientStreamingStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendDuration(time:Seconds message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextDuration(duration:ContextDuration message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveDuration() returns time:Seconds|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <time:Seconds>payload;
        }
    }

    isolated remote function receiveContextDuration() returns duration:ContextDuration|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <time:Seconds>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class BidirectionalStreamingStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendDuration(time:Seconds message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextDuration(duration:ContextDuration message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveDuration() returns time:Seconds|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <time:Seconds>payload;
        }
    }

    isolated remote function receiveContextDuration() returns duration:ContextDuration|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <time:Seconds>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class DurationHandlerDurationCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendDuration(time:Seconds response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextDuration(duration:ContextDuration response) returns grpc:Error? {
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

const string ROOT_DESCRIPTOR_DURATION_TYPE2 = "0A146475726174696F6E5F74797065322E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F32C6020A0F4475726174696F6E48616E646C657212430A09756E61727943616C6C12192E676F6F676C652E70726F746F6275662E4475726174696F6E1A192E676F6F676C652E70726F746F6275662E4475726174696F6E2200124B0A0F73657276657253747265616D696E6712192E676F6F676C652E70726F746F6275662E4475726174696F6E1A192E676F6F676C652E70726F746F6275662E4475726174696F6E22003001124B0A0F636C69656E7453747265616D696E6712192E676F6F676C652E70726F746F6275662E4475726174696F6E1A192E676F6F676C652E70726F746F6275662E4475726174696F6E2200280112540A166269646972656374696F6E616C53747265616D696E6712192E676F6F676C652E70726F746F6275662E4475726174696F6E1A192E676F6F676C652E70726F746F6275662E4475726174696F6E220028013001620670726F746F33";

public isolated function getDescriptorMapDurationType2() returns map<string> {
    return {"duration_type2.proto": "0A146475726174696F6E5F74797065322E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F32C6020A0F4475726174696F6E48616E646C657212430A09756E61727943616C6C12192E676F6F676C652E70726F746F6275662E4475726174696F6E1A192E676F6F676C652E70726F746F6275662E4475726174696F6E2200124B0A0F73657276657253747265616D696E6712192E676F6F676C652E70726F746F6275662E4475726174696F6E1A192E676F6F676C652E70726F746F6275662E4475726174696F6E22003001124B0A0F636C69656E7453747265616D696E6712192E676F6F676C652E70726F746F6275662E4475726174696F6E1A192E676F6F676C652E70726F746F6275662E4475726174696F6E2200280112540A166269646972656374696F6E616C53747265616D696E6712192E676F6F676C652E70726F746F6275662E4475726174696F6E1A192E676F6F676C652E70726F746F6275662E4475726174696F6E220028013001620670726F746F33", "google/protobuf/duration.proto": "0A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F120F676F6F676C652E70726F746F627566223A0A084475726174696F6E12180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342570A13636F6D2E676F6F676C652E70726F746F627566420D4475726174696F6E50726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

