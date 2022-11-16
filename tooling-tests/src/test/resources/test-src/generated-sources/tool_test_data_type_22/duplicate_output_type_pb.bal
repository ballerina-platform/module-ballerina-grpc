import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.empty;
import ballerina/protobuf.types.wrappers;

public const string DUPLICATE_OUTPUT_TYPE_DESC = "0A1B6475706C69636174655F6F75747075745F747970652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F225B0A05416C62756D120E0A0269641801200128095202696412140A057469746C6518022001280952057469746C6512160A06617274697374180320012809520661727469737412140A0570726963651804200128025205707269636532EC010A0B5265636F726453746F726512220A0C757064617465416C62756D7312062E416C62756D1A062E416C62756D28013001122D0A09676574416C62756D7312162E676F6F676C652E70726F746F6275662E456D7074791A062E416C62756D300112340A0C676574416C62756D42794964121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A062E416C62756D12360A0D676574546F74616C56616C756512062E416C62756D1A1B2E676F6F676C652E70726F746F6275662E496E74333256616C75652801121C0A0A73746F7265416C62756D12062E416C62756D1A062E416C62756D620670726F746F33";

public isolated client class RecordStoreClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, DUPLICATE_OUTPUT_TYPE_DESC);
    }

    isolated remote function getAlbumById(string|wrappers:ContextString req) returns Album|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RecordStore/getAlbumById", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Album>result;
    }

    isolated remote function getAlbumByIdContext(string|wrappers:ContextString req) returns ContextAlbum|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RecordStore/getAlbumById", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Album>result, headers: respHeaders};
    }

    isolated remote function storeAlbum(Album|ContextAlbum req) returns Album|grpc:Error {
        map<string|string[]> headers = {};
        Album message;
        if req is ContextAlbum {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RecordStore/storeAlbum", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Album>result;
    }

    isolated remote function storeAlbumContext(Album|ContextAlbum req) returns ContextAlbum|grpc:Error {
        map<string|string[]> headers = {};
        Album message;
        if req is ContextAlbum {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RecordStore/storeAlbum", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Album>result, headers: respHeaders};
    }

    isolated remote function getTotalValue() returns GetTotalValueStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("RecordStore/getTotalValue");
        return new GetTotalValueStreamingClient(sClient);
    }

    isolated remote function getAlbums() returns stream<Album, grpc:Error?>|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeServerStreaming("RecordStore/getAlbums", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        AlbumStream outputStream = new AlbumStream(result);
        return new stream<Album, grpc:Error?>(outputStream);
    }

    isolated remote function getAlbumsContext() returns ContextAlbumStream|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeServerStreaming("RecordStore/getAlbums", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        AlbumStream outputStream = new AlbumStream(result);
        return {content: new stream<Album, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function updateAlbums() returns UpdateAlbumsStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("RecordStore/updateAlbums");
        return new UpdateAlbumsStreamingClient(sClient);
    }
}

public client class GetTotalValueStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendAlbum(Album message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextAlbum(ContextAlbum message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveInt() returns int|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <int>payload;
        }
    }

    isolated remote function receiveContextInt() returns wrappers:ContextInt|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <int>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class AlbumStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Album value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|Album value;|} nextRecord = {value: <Album>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class UpdateAlbumsStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendAlbum(Album message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextAlbum(ContextAlbum message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveAlbum() returns Album|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <Album>payload;
        }
    }

    isolated remote function receiveContextAlbum() returns ContextAlbum|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <Album>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class RecordStoreIntCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt(int response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt(wrappers:ContextInt response) returns grpc:Error? {
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

public client class RecordStoreAlbumCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAlbum(Album response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAlbum(ContextAlbum response) returns grpc:Error? {
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

public type ContextAlbumStream record {|
    stream<Album, error?> content;
    map<string|string[]> headers;
|};

public type ContextAlbum record {|
    Album content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: DUPLICATE_OUTPUT_TYPE_DESC}
public type Album record {|
    string id = "";
    string title = "";
    string artist = "";
    float price = 0.0;
|};

