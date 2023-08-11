// Copyright (c) 2023 WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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
import ballerina/protobuf.types.wrappers;

public const string CHILD_DESC = "0A0B6368696C642E70726F746F120C656E756D5F696D706F7274731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A0C706172656E742E70726F746F22580A0E4C6F636174696F6E44657461696C12120A046E616D6518012001280952046E616D6512320A086C6F636174696F6E18022001280E32162E656E756D5F696D706F7274732E4C6F636174696F6E52086C6F636174696F6E325C0A0F4C6F636174696F6E5365727669636512490A0B4765744C6F636174696F6E121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E656E756D5F696D706F7274732E4C6F636174696F6E44657461696C620670726F746F33";
public const map<string> CHILD_DESCRIPTOR_MAP = {"parent.proto": PARENT_DESC};

public isolated client class LocationServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CHILD_DESC, CHILD_DESCRIPTOR_MAP);
    }

    isolated remote function GetLocation(string|wrappers:ContextString req) returns LocationDetail|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("enum_imports.LocationService/GetLocation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <LocationDetail>result;
    }

    isolated remote function GetLocationContext(string|wrappers:ContextString req) returns ContextLocationDetail|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("enum_imports.LocationService/GetLocation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <LocationDetail>result, headers: respHeaders};
    }
}

public client class LocationServiceLocationDetailCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendLocationDetail(LocationDetail response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextLocationDetail(ContextLocationDetail response) returns grpc:Error? {
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

public type ContextLocationDetail record {|
    LocationDetail content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CHILD_DESC}
public type LocationDetail record {|
    string name = "";
    Location location = LocationA;
|};

