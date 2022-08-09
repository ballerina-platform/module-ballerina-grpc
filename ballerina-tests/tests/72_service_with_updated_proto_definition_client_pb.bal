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
import ballerina/protobuf;
import ballerina/time;
import ballerina/protobuf.types.empty;

const string SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC = "0A3537325F736572766963655F776974685F757064617465645F70726F746F5F646566696E6974696F6E5F636C69656E742E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F22450A164765744F7267616E697A6174696F6E52657175657374122B0A116F7267616E697A6174696F6E5F6E616D6518012001280952106F7267616E697A6174696F6E4E616D6522670A174765744F7267616E697A6174696F6E526573706F6E736512310A0C6F7267616E697A6174696F6E18012001280B320D2E4F7267616E697A6174696F6E520C6F7267616E697A6174696F6E12190A0869735F61646D696E1802200128085207697341646D696E225E0A0C4F7267616E697A6174696F6E120E0A0269641801200128035202696412120A047575696418022001280952047575696412160A0668616E646C65180320012809520668616E646C6512120A046E616D6518042001280952046E616D65228F020A0547726F7570120E0A0269641801200128035202696412190A086F72675F6E616D6518022001280952076F72674E616D6512190A086F72675F7575696418032001280952076F72675575696412200A0B6465736372697074696F6E180420012809520B6465736372697074696F6E12230A0D64656661756C745F67726F7570180520012808520C64656661756C7447726F757012140A046E616D65180620012809480052046E616D65121B0A087265675F6E616D65180720012809480052077265674E616D6512360A0A6F746865725F6461746118082001280B32172E676F6F676C652E70726F746F6275662E53747275637452096F7468657244617461420E0A0C646973706C61795F6E616D6522A0020A0455736572120E0A0269641801200128035202696412150A066964705F696418022001280952056964704964121F0A0B706963747572655F75726C180320012809520A7069637475726555726C12140A05656D61696C1804200128095205656D61696C12210A0C646973706C61795F6E616D65180520012809520B646973706C61794E616D6512210A0C69735F616E6F6E796D6F7573180620012808520B6973416E6F6E796D6F757312390A0A637265617465645F617418072001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520963726561746564417412390A0A657870697265645F617418082001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705209657870697265644174327F0A0B557365725365727669636512440A0F4765744F7267616E697A6174696F6E12172E4765744F7267616E697A6174696F6E526571756573741A182E4765744F7267616E697A6174696F6E526573706F6E7365122A0A0847657447726F757012162E676F6F676C652E70726F746F6275662E456D7074791A062E47726F7570620670726F746F33";

public isolated client class UserServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC);
    }

    isolated remote function GetOrganization(GetOrganizationRequest|ContextGetOrganizationRequest req) returns GetOrganizationResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetOrganizationRequest message;
        if req is ContextGetOrganizationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("UserService/GetOrganization", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <GetOrganizationResponse>result;
    }

    isolated remote function GetOrganizationContext(GetOrganizationRequest|ContextGetOrganizationRequest req) returns ContextGetOrganizationResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetOrganizationRequest message;
        if req is ContextGetOrganizationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("UserService/GetOrganization", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <GetOrganizationResponse>result, headers: respHeaders};
    }

    isolated remote function GetGroup() returns Group|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("UserService/GetGroup", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Group>result;
    }

    isolated remote function GetGroupContext() returns ContextGroup|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("UserService/GetGroup", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Group>result, headers: respHeaders};
    }
}

public client class UserServiceGetOrganizationResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendGetOrganizationResponse(GetOrganizationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextGetOrganizationResponse(ContextGetOrganizationResponse response) returns grpc:Error? {
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

public client class UserServiceGroupCaller {
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

public type ContextGetOrganizationRequest record {|
    GetOrganizationRequest content;
    map<string|string[]> headers;
|};

public type ContextGetOrganizationResponse record {|
    GetOrganizationResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC}
public type Group record {|
    int id = 0;
    string org_name = "";
    string org_uuid = "";
    string description = "";
    boolean default_group = false;
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
public type Organization record {|
    int id = 0;
    string uuid = "";
    string 'handle = "";
    string name = "";
|};

@protobuf:Descriptor {value: SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC}
public type User record {|
    int id = 0;
    string idp_id = "";
    string picture_url = "";
    string email = "";
    string display_name = "";
    boolean is_anonymous = false;
    time:Utc created_at = [0, 0.0d];
    time:Utc expired_at = [0, 0.0d];
|};

@protobuf:Descriptor {value: SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC}
public type GetOrganizationRequest record {|
    string organization_name = "";
|};

@protobuf:Descriptor {value: SERVICE_WITH_UPDATED_PROTO_DEFINITION_CLIENT_DESC}
public type GetOrganizationResponse record {|
    Organization organization = {};
    boolean is_admin = false;
|};

