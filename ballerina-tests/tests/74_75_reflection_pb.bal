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

const string REFLECTION_DESC = "0A107265666C656374696F6E2E70726F746F1217677270632E7265666C656374696F6E2E7631616C70686122F8020A175365727665725265666C656374696F6E5265717565737412120A04686F73741801200128095204686F7374122A0A1066696C655F62795F66696C656E616D651803200128094800520E66696C65427946696C656E616D6512360A1666696C655F636F6E7461696E696E675F73796D626F6C1804200128094800521466696C65436F6E7461696E696E6753796D626F6C12670A1966696C655F636F6E7461696E696E675F657874656E73696F6E18052001280B32292E677270632E7265666C656374696F6E2E7631616C7068612E457874656E73696F6E526571756573744800521766696C65436F6E7461696E696E67457874656E73696F6E12420A1D616C6C5F657874656E73696F6E5F6E756D626572735F6F665F7479706518062001280948005219616C6C457874656E73696F6E4E756D626572734F665479706512250A0D6C6973745F73657276696365731807200128094800520C6C697374536572766963657342110A0F6D6573736167655F7265717565737422660A10457874656E73696F6E5265717565737412270A0F636F6E7461696E696E675F74797065180120012809520E636F6E7461696E696E675479706512290A10657874656E73696F6E5F6E756D626572180220012805520F657874656E73696F6E4E756D62657222C7040A185365727665725265666C656374696F6E526573706F6E7365121D0A0A76616C69645F686F7374180120012809520976616C6964486F7374125B0A106F726967696E616C5F7265717565737418022001280B32302E677270632E7265666C656374696F6E2E7631616C7068612E5365727665725265666C656374696F6E52657175657374520F6F726967696E616C52657175657374126B0A1866696C655F64657363726970746F725F726573706F6E736518042001280B322F2E677270632E7265666C656374696F6E2E7631616C7068612E46696C6544657363726970746F72526573706F6E73654800521666696C6544657363726970746F72526573706F6E736512770A1E616C6C5F657874656E73696F6E5F6E756D626572735F726573706F6E736518052001280B32302E677270632E7265666C656374696F6E2E7631616C7068612E457874656E73696F6E4E756D626572526573706F6E73654800521B616C6C457874656E73696F6E4E756D62657273526573706F6E736512640A166C6973745F73657276696365735F726573706F6E736518062001280B322C2E677270632E7265666C656374696F6E2E7631616C7068612E4C69737453657276696365526573706F6E7365480052146C6973745365727669636573526573706F6E7365124F0A0E6572726F725F726573706F6E736518072001280B32262E677270632E7265666C656374696F6E2E7631616C7068612E4572726F72526573706F6E73654800520D6572726F72526573706F6E736542120A106D6573736167655F726573706F6E7365224C0A1646696C6544657363726970746F72526573706F6E736512320A1566696C655F64657363726970746F725F70726F746F18012003280C521366696C6544657363726970746F7250726F746F226A0A17457874656E73696F6E4E756D626572526573706F6E736512240A0E626173655F747970655F6E616D65180120012809520C62617365547970654E616D6512290A10657874656E73696F6E5F6E756D626572180220032805520F657874656E73696F6E4E756D62657222590A134C69737453657276696365526573706F6E736512420A077365727669636518012003280B32282E677270632E7265666C656374696F6E2E7631616C7068612E53657276696365526573706F6E736552077365727669636522250A0F53657276696365526573706F6E736512120A046E616D6518012001280952046E616D6522530A0D4572726F72526573706F6E7365121D0A0A6572726F725F636F646518012001280552096572726F72436F646512230A0D6572726F725F6D657373616765180220012809520C6572726F724D6573736167653293010A105365727665725265666C656374696F6E127F0A145365727665725265666C656374696F6E496E666F12302E677270632E7265666C656374696F6E2E7631616C7068612E5365727665725265666C656374696F6E526571756573741A312E677270632E7265666C656374696F6E2E7631616C7068612E5365727665725265666C656374696F6E526573706F6E736528013001620670726F746F33";

public isolated client class ServerReflectionClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, REFLECTION_DESC);
    }

    isolated remote function ServerReflectionInfo() returns ServerReflectionInfoStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("grpc.reflection.v1alpha.ServerReflection/ServerReflectionInfo");
        return new ServerReflectionInfoStreamingClient(sClient);
    }
}

public isolated client class ServerReflectionInfoStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendServerReflectionRequest(ServerReflectionRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextServerReflectionRequest(ContextServerReflectionRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveServerReflectionResponse() returns ServerReflectionResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <ServerReflectionResponse>payload;
        }
    }

    isolated remote function receiveContextServerReflectionResponse() returns ContextServerReflectionResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <ServerReflectionResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class ServerReflectionServerReflectionResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendServerReflectionResponse(ServerReflectionResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextServerReflectionResponse(ContextServerReflectionResponse response) returns grpc:Error? {
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

public type ContextServerReflectionRequestStream record {|
    stream<ServerReflectionRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextServerReflectionResponseStream record {|
    stream<ServerReflectionResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextServerReflectionRequest record {|
    ServerReflectionRequest content;
    map<string|string[]> headers;
|};

public type ContextServerReflectionResponse record {|
    ServerReflectionResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: REFLECTION_DESC}
public type ExtensionRequest record {|
    string containing_type = "";
    int extension_number = 0;
|};

@protobuf:Descriptor {value: REFLECTION_DESC}
public type ServiceResponse record {|
    string name = "";
|};

@protobuf:Descriptor {value: REFLECTION_DESC}
public type FileDescriptorResponse record {|
    byte[] file_descriptor_proto = [];
|};

@protobuf:Descriptor {value: REFLECTION_DESC}
public type ServerReflectionRequest record {|
    string host = "";
    string file_by_filename?;
    string file_containing_symbol?;
    ExtensionRequest file_containing_extension?;
    string all_extension_numbers_of_type?;
    string list_services?;
|};

isolated function isValidServerreflectionrequest(ServerReflectionRequest r) returns boolean {
    int message_requestCount = 0;
    if !(r?.file_by_filename is ()) {
        message_requestCount += 1;
    }
    if !(r?.file_containing_symbol is ()) {
        message_requestCount += 1;
    }
    if !(r?.file_containing_extension is ()) {
        message_requestCount += 1;
    }
    if !(r?.all_extension_numbers_of_type is ()) {
        message_requestCount += 1;
    }
    if !(r?.list_services is ()) {
        message_requestCount += 1;
    }
    if (message_requestCount > 1) {
        return false;
    }
    return true;
}

isolated function setServerReflectionRequest_FileByFilename(ServerReflectionRequest r, string file_by_filename) {
    r.file_by_filename = file_by_filename;
    _ = r.removeIfHasKey("file_containing_symbol");
    _ = r.removeIfHasKey("file_containing_extension");
    _ = r.removeIfHasKey("all_extension_numbers_of_type");
    _ = r.removeIfHasKey("list_services");
}

isolated function setServerReflectionRequest_FileContainingSymbol(ServerReflectionRequest r, string file_containing_symbol) {
    r.file_containing_symbol = file_containing_symbol;
    _ = r.removeIfHasKey("file_by_filename");
    _ = r.removeIfHasKey("file_containing_extension");
    _ = r.removeIfHasKey("all_extension_numbers_of_type");
    _ = r.removeIfHasKey("list_services");
}

isolated function setServerReflectionRequest_FileContainingExtension(ServerReflectionRequest r, ExtensionRequest file_containing_extension) {
    r.file_containing_extension = file_containing_extension;
    _ = r.removeIfHasKey("file_by_filename");
    _ = r.removeIfHasKey("file_containing_symbol");
    _ = r.removeIfHasKey("all_extension_numbers_of_type");
    _ = r.removeIfHasKey("list_services");
}

isolated function setServerReflectionRequest_AllExtensionNumbersOfType(ServerReflectionRequest r, string all_extension_numbers_of_type) {
    r.all_extension_numbers_of_type = all_extension_numbers_of_type;
    _ = r.removeIfHasKey("file_by_filename");
    _ = r.removeIfHasKey("file_containing_symbol");
    _ = r.removeIfHasKey("file_containing_extension");
    _ = r.removeIfHasKey("list_services");
}

isolated function setServerReflectionRequest_ListServices(ServerReflectionRequest r, string list_services) {
    r.list_services = list_services;
    _ = r.removeIfHasKey("file_by_filename");
    _ = r.removeIfHasKey("file_containing_symbol");
    _ = r.removeIfHasKey("file_containing_extension");
    _ = r.removeIfHasKey("all_extension_numbers_of_type");
}

@protobuf:Descriptor {value: REFLECTION_DESC}
public type ExtensionNumberResponse record {|
    string base_type_name = "";
    int[] extension_number = [];
|};

@protobuf:Descriptor {value: REFLECTION_DESC}
public type ServerReflectionResponse record {|
    string valid_host = "";
    ServerReflectionRequest original_request = {};
    FileDescriptorResponse file_descriptor_response?;
    ExtensionNumberResponse all_extension_numbers_response?;
    ListServiceResponse list_services_response?;
    ErrorResponse error_response?;
|};

isolated function isValidServerreflectionresponse(ServerReflectionResponse r) returns boolean {
    int message_responseCount = 0;
    if !(r?.file_descriptor_response is ()) {
        message_responseCount += 1;
    }
    if !(r?.all_extension_numbers_response is ()) {
        message_responseCount += 1;
    }
    if !(r?.list_services_response is ()) {
        message_responseCount += 1;
    }
    if !(r?.error_response is ()) {
        message_responseCount += 1;
    }
    if (message_responseCount > 1) {
        return false;
    }
    return true;
}

isolated function setServerReflectionResponse_FileDescriptorResponse(ServerReflectionResponse r, FileDescriptorResponse file_descriptor_response) {
    r.file_descriptor_response = file_descriptor_response;
    _ = r.removeIfHasKey("all_extension_numbers_response");
    _ = r.removeIfHasKey("list_services_response");
    _ = r.removeIfHasKey("error_response");
}

isolated function setServerReflectionResponse_AllExtensionNumbersResponse(ServerReflectionResponse r, ExtensionNumberResponse all_extension_numbers_response) {
    r.all_extension_numbers_response = all_extension_numbers_response;
    _ = r.removeIfHasKey("file_descriptor_response");
    _ = r.removeIfHasKey("list_services_response");
    _ = r.removeIfHasKey("error_response");
}

isolated function setServerReflectionResponse_ListServicesResponse(ServerReflectionResponse r, ListServiceResponse list_services_response) {
    r.list_services_response = list_services_response;
    _ = r.removeIfHasKey("file_descriptor_response");
    _ = r.removeIfHasKey("all_extension_numbers_response");
    _ = r.removeIfHasKey("error_response");
}

isolated function setServerReflectionResponse_ErrorResponse(ServerReflectionResponse r, ErrorResponse error_response) {
    r.error_response = error_response;
    _ = r.removeIfHasKey("file_descriptor_response");
    _ = r.removeIfHasKey("all_extension_numbers_response");
    _ = r.removeIfHasKey("list_services_response");
}

@protobuf:Descriptor {value: REFLECTION_DESC}
public type ListServiceResponse record {|
    ServiceResponse[] 'service = [];
|};

@protobuf:Descriptor {value: REFLECTION_DESC}
public type ErrorResponse record {|
    int error_code = 0;
    string error_message = "";
|};

