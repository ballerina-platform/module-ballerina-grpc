import ballerina/grpc;
import ballerina/protobuf.types.struct;
import ballerina/grpc.types.struct as sstruct;

const string STRUCT_TYPE2_DESC = "0A127374727563745F74797065322E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F32B4020A0D53747275637448616E646C6572123F0A09756E61727943616C6C12172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220012470A0F73657276657253747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200300112470A0F636C69656E7453747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200280112500A166269646972656374696F6E616C53747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220028013001620670726F746F33";

public isolated client class StructHandlerClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, STRUCT_TYPE2_DESC);
    }

    isolated remote function unaryCall(map<anydata>|struct:ContextStruct req) returns map<anydata>|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructHandler/unaryCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <map<anydata>>result;
    }

    isolated remote function unaryCallContext(map<anydata>|struct:ContextStruct req) returns struct:ContextStruct|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructHandler/unaryCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <map<anydata>>result, headers: respHeaders};
    }

    isolated remote function clientStreaming() returns ClientStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("StructHandler/clientStreaming");
        return new ClientStreamingStreamingClient(sClient);
    }

    isolated remote function serverStreaming(map<anydata>|struct:ContextStruct req) returns stream<map<anydata>, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("StructHandler/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        sstruct:StructStream outputStream = new sstruct:StructStream(result);
        return new stream<map<anydata>, grpc:Error?>(outputStream);
    }

    isolated remote function serverStreamingContext(map<anydata>|struct:ContextStruct req) returns struct:ContextStructStream|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("StructHandler/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        sstruct:StructStream outputStream = new sstruct:StructStream(result);
        return {content: new stream<map<anydata>, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectionalStreaming() returns BidirectionalStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("StructHandler/bidirectionalStreaming");
        return new BidirectionalStreamingStreamingClient(sClient);
    }
}

public client class ClientStreamingStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStruct(map<anydata> message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStruct(struct:ContextStruct message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStruct() returns map<anydata>|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <map<anydata>>payload;
        }
    }

    isolated remote function receiveContextStruct() returns struct:ContextStruct|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <map<anydata>>payload, headers: headers};
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

    isolated remote function sendStruct(map<anydata> message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStruct(struct:ContextStruct message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStruct() returns map<anydata>|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <map<anydata>>payload;
        }
    }

    isolated remote function receiveContextStruct() returns struct:ContextStruct|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <map<anydata>>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

