import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.empty;

const string SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC = "0A3537325F736572766963655F776974685F757064617465645F70726F746F5F646566696E6974696F6E5F636C69656E742E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F22300A0F476574436C61737352657175657374121D0A0A636C6173735F6E616D651801200128095209636C6173734E616D65225A0A10476574436C617373526573706F6E736512250A0A636C6173735F6461746118012001280B32062E436C6173735209636C61737344617461121F0A0B6861735F74656163686572180220012808520A6861735465616368657222670A05436C61737312160A066E756D62657218012001280352066E756D626572121A0A086C6F636174696F6E18022001280952086C6F636174696F6E12160A066C656164657218032001280952066C656164657212120A046E616D6518042001280952046E616D65228A020A0547726F757012190A08675F6E756D6265721801200128035207674E756D62657212150A06675F6E616D651802200128095205674E616D6512110A04675F6964180320012809520367496412200A0B6465736372697074696F6E180420012809520B6465736372697074696F6E121F0A0B66697273745F67726F7570180520012808520A666972737447726F757012140A046E616D65180620012809480052046E616D65121B0A087265675F6E616D65180720012809480052077265674E616D6512360A0A6F746865725F6461746118082001280B32172E676F6F676C652E70726F746F6275662E53747275637452096F7468657244617461420E0A0C646973706C61795F6E616D65326D0A0E5570646174656453657276696365122F0A08476574436C61737312102E476574436C617373526571756573741A112E476574436C617373526573706F6E7365122A0A0847657447726F757012162E676F6F676C652E70726F746F6275662E456D7074791A062E47726F7570620670726F746F33";

public isolated client class UpdatedServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC);
    }

    isolated remote function GetClass(GetClassRequest|ContextGetClassRequest req) returns GetClassResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetClassRequest message;
        if req is ContextGetClassRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("UpdatedService/GetClass", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <GetClassResponse>result;
    }

    isolated remote function GetClassContext(GetClassRequest|ContextGetClassRequest req) returns ContextGetClassResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetClassRequest message;
        if req is ContextGetClassRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("UpdatedService/GetClass", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <GetClassResponse>result, headers: respHeaders};
    }

    isolated remote function GetGroup() returns Group|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("UpdatedService/GetGroup", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Group>result;
    }

    isolated remote function GetGroupContext() returns ContextGroup|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("UpdatedService/GetGroup", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Group>result, headers: respHeaders};
    }
}

public client class UpdatedServiceGetClassResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendGetClassResponse(GetClassResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextGetClassResponse(ContextGetClassResponse response) returns grpc:Error? {
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

public client class UpdatedServiceGroupCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendGroup(Group response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextGroup(ContextGroup response) returns grpc:Error? {
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

public type ContextGroup record {|
    Group content;
    map<string|string[]> headers;
|};

public type ContextGetClassResponse record {|
    GetClassResponse content;
    map<string|string[]> headers;
|};

public type ContextGetClassRequest record {|
    GetClassRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC}
public type Group record {|
    int g_number = 0;
    string g_name = "";
    string g_id = "";
    string description = "";
    boolean first_group = false;
    map<anydata> other_data = {};
    string name?;
    string reg_name?;
|};

isolated function isValidGroup(Group r) returns boolean {
    int display_nameCount = 0;
    if !(r?.name is ()) {
        display_nameCount += 1;
    }
    if !(r?.reg_name is ()) {
        display_nameCount += 1;
    }
    if (display_nameCount > 1) {
        return false;
    }
    return true;
}

isolated function setGroup_Name(Group r, string name) {
    r.name = name;
    _ = r.removeIfHasKey("reg_name");
}

isolated function setGroup_RegName(Group r, string reg_name) {
    r.reg_name = reg_name;
    _ = r.removeIfHasKey("name");
}

@protobuf:Descriptor {value: SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC}
public type GetClassResponse record {|
    Class class_data = {};
    boolean has_teacher = false;
|};

@protobuf:Descriptor {value: SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC}
public type GetClassRequest record {|
    string class_name = "";
|};

@protobuf:Descriptor {value: SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC}
public type Class record {|
    int number = 0;
    string location = "";
    string leader = "";
    string name = "";
|};

