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
import ballerina/protobuf.types.'any;

public isolated client class AnyTypeArrayClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_65_ANY_TYPE_ARRAY, getDescriptorMap65AnyTypeArray());
    }

    isolated remote function unaryCall1(AnyTypeArrayRequest|ContextAnyTypeArrayRequest req) returns AnyTypeArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        AnyTypeArrayRequest message;
        if req is ContextAnyTypeArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("AnyTypeArray/unaryCall1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AnyTypeArrayResponse>result;
    }

    isolated remote function unaryCall1Context(AnyTypeArrayRequest|ContextAnyTypeArrayRequest req) returns ContextAnyTypeArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        AnyTypeArrayRequest message;
        if req is ContextAnyTypeArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("AnyTypeArray/unaryCall1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AnyTypeArrayResponse>result, headers: respHeaders};
    }
}

public client class AnyTypeArrayAnyTypeArrayResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAnyTypeArrayResponse(AnyTypeArrayResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAnyTypeArrayResponse(ContextAnyTypeArrayResponse response) returns grpc:Error? {
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

public type ContextAnyTypeArrayResponse record {|
    AnyTypeArrayResponse content;
    map<string|string[]> headers;
|};

public type ContextAnyTypeArrayRequest record {|
    AnyTypeArrayRequest content;
    map<string|string[]> headers;
|};

public type AnyTypeArrayResponse record {|
    string name = "";
    int code = 0;
    'any:Any[] details = [];
|};

public type AnyTypeArrayMsg record {|
    string name = "";
    int code = 0;
|};

public type AnyTypeArrayRequest record {|
    string name = "";
    'any:Any[] details = [];
|};

const string ROOT_DESCRIPTOR_65_ANY_TYPE_ARRAY = "0A1736355F616E795F747970655F61727261792E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F22590A13416E795479706541727261795265717565737412120A046E616D6518012001280952046E616D65122E0A0764657461696C7318022003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C73226E0A14416E79547970654172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465122E0A0764657461696C7318032003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C7322390A0F416E795479706541727261794D736712120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465324B0A0C416E79547970654172726179123B0A0A756E61727943616C6C3112142E416E79547970654172726179526571756573741A152E416E79547970654172726179526573706F6E73652200620670726F746F33";

public isolated function getDescriptorMap65AnyTypeArray() returns map<string> {
    return {"65_any_type_array.proto": "0A1736355F616E795F747970655F61727261792E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F22590A13416E795479706541727261795265717565737412120A046E616D6518012001280952046E616D65122E0A0764657461696C7318022003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C73226E0A14416E79547970654172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465122E0A0764657461696C7318032003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C7322390A0F416E795479706541727261794D736712120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465324B0A0C416E79547970654172726179123B0A0A756E61727943616C6C3112142E416E79547970654172726179526571756573741A152E416E79547970654172726179526573706F6E73652200620670726F746F33", "google/protobuf/any.proto": "0A19676F6F676C652F70726F746F6275662F616E792E70726F746F120F676F6F676C652E70726F746F62756622360A03416E7912190A08747970655F75726C18012001280952077479706555726C12140A0576616C756518022001280C520576616C7565424F0A13636F6D2E676F6F676C652E70726F746F6275664208416E7950726F746F50015A057479706573A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}
