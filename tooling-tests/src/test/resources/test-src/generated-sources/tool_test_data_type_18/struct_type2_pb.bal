import ballerina/grpc;
import ballerina/protobuf.types.struct;
import ballerina/grpc.types.struct as sstruct;

public isolated client class StructHandlerClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_STRUCT_TYPE2, getDescriptorMapStructType2());
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

public client class StructHandlerStructCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStruct(map<anydata> response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStruct(struct:ContextStruct response) returns grpc:Error? {
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

const string ROOT_DESCRIPTOR_STRUCT_TYPE2 = "0A127374727563745F74797065322E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F32B4020A0D53747275637448616E646C6572123F0A09756E61727943616C6C12172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220012470A0F73657276657253747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200300112470A0F636C69656E7453747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200280112500A166269646972656374696F6E616C53747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220028013001620670726F746F33";

public isolated function getDescriptorMapStructType2() returns map<string> {
    return {"google/protobuf/struct.proto": "0A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F120F676F6F676C652E70726F746F6275662298010A06537472756374123B0A066669656C647318012003280B32232E676F6F676C652E70726F746F6275662E5374727563742E4669656C6473456E74727952066669656C64731A510A0B4669656C6473456E74727912100A036B657918012001280952036B6579122C0A0576616C756518022001280B32162E676F6F676C652E70726F746F6275662E56616C7565520576616C75653A02380122B2020A0556616C7565123B0A0A6E756C6C5F76616C756518012001280E321A2E676F6F676C652E70726F746F6275662E4E756C6C56616C7565480052096E756C6C56616C756512230A0C6E756D6265725F76616C75651802200128014800520B6E756D62657256616C756512230A0C737472696E675F76616C75651803200128094800520B737472696E6756616C7565121F0A0A626F6F6C5F76616C756518042001280848005209626F6F6C56616C7565123C0A0C7374727563745F76616C756518052001280B32172E676F6F676C652E70726F746F6275662E5374727563744800520B73747275637456616C7565123B0A0A6C6973745F76616C756518062001280B321A2E676F6F676C652E70726F746F6275662E4C69737456616C7565480052096C69737456616C756542060A046B696E64223B0A094C69737456616C7565122E0A0676616C75657318012003280B32162E676F6F676C652E70726F746F6275662E56616C7565520676616C7565732A1B0A094E756C6C56616C7565120E0A0A4E554C4C5F56414C5545100042550A13636F6D2E676F6F676C652E70726F746F627566420B53747275637450726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "struct_type2.proto": "0A127374727563745F74797065322E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F32B4020A0D53747275637448616E646C6572123F0A09756E61727943616C6C12172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220012470A0F73657276657253747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200300112470A0F636C69656E7453747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200280112500A166269646972656374696F6E616C53747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220028013001620670726F746F33"};
}

