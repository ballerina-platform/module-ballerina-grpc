import ballerina/grpc;
import ballerina/protobuf;

public const string SERVICE_WITH_NESTED_MESSAGES_DESC = "0A22736572766963655F776974685F6E65737465645F6D657373616765732E70726F746F229A010A144E6573746564526571756573744D65737361676512180A076D65737361676518012001280952076D657373616765122C0A0B6279655F7265717565737418022001280B320B2E42796552657175657374520A6279655265717565737412200A06665F696E666F18032001280B32092E46696C65496E666F520566496E666F12180A046261727318042003280B32042E42617A52046261727322310A154E6573746564526573706F6E73654D65737361676512180A076D65737361676518012001280952076D657373616765223A0A0A4279655265717565737412140A0567726565741801200128095205677265657412160A0362617A18022001280B32042E42617A520362617A22170A0342617A12100A036167651801200128095203616765226D0A0846696C65496E666F120E0A0269641801200128095202696412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E122A0A0D6F62736572766162696C69747918032001280B32042E4C6F67520D6F62736572766162696C697479222B0A034C6F6712240A0D6F62736572766162696C697479180120012809520D6F62736572766162696C69747932520A1853657276696365576974684E65737465644D65737361676512360A0568656C6C6F12152E4E6573746564526571756573744D6573736167651A162E4E6573746564526573706F6E73654D657373616765620670726F746F33";

public isolated client class ServiceWithNestedMessageClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVICE_WITH_NESTED_MESSAGES_DESC);
    }

    isolated remote function hello(NestedRequestMessage|ContextNestedRequestMessage req) returns NestedResponseMessage|grpc:Error {
        map<string|string[]> headers = {};
        NestedRequestMessage message;
        if req is ContextNestedRequestMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ServiceWithNestedMessage/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <NestedResponseMessage>result;
    }

    isolated remote function helloContext(NestedRequestMessage|ContextNestedRequestMessage req) returns ContextNestedResponseMessage|grpc:Error {
        map<string|string[]> headers = {};
        NestedRequestMessage message;
        if req is ContextNestedRequestMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ServiceWithNestedMessage/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <NestedResponseMessage>result, headers: respHeaders};
    }
}

public type ContextNestedRequestMessage record {|
    NestedRequestMessage content;
    map<string|string[]> headers;
|};

public type ContextNestedResponseMessage record {|
    NestedResponseMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVICE_WITH_NESTED_MESSAGES_DESC}
public type ByeRequest record {|
    string greet = "";
    Baz baz = {};
|};

@protobuf:Descriptor {value: SERVICE_WITH_NESTED_MESSAGES_DESC}
public type FileInfo record {|
    string id = "";
    string latest_version = "";
    Log observability = {};
|};

@protobuf:Descriptor {value: SERVICE_WITH_NESTED_MESSAGES_DESC}
public type NestedRequestMessage record {|
    string message = "";
    ByeRequest bye_request = {};
    FileInfo f_info = {};
    Baz[] bars = [];
|};

@protobuf:Descriptor {value: SERVICE_WITH_NESTED_MESSAGES_DESC}
public type Log record {|
    string observability = "";
|};

@protobuf:Descriptor {value: SERVICE_WITH_NESTED_MESSAGES_DESC}
public type NestedResponseMessage record {|
    string message = "";
|};

@protobuf:Descriptor {value: SERVICE_WITH_NESTED_MESSAGES_DESC}
public type Baz record {|
    string age = "";
|};

