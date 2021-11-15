// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/grpc.types.'any as sany;

public isolated client class AnyTypeServerClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_ANY, getDescriptorMapAny());
    }

    isolated remote function unaryCall1('any:Any|'any:ContextAny req) returns 'any:Any|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("AnyTypeServer/unaryCall1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <'any:Any>result;
    }

    isolated remote function unaryCall1Context('any:Any|'any:ContextAny req) returns 'any:ContextAny|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("AnyTypeServer/unaryCall1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <'any:Any>result, headers: respHeaders};
    }

    isolated remote function unaryCall2('any:Any|'any:ContextAny req) returns 'any:Any|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("AnyTypeServer/unaryCall2", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <'any:Any>result;
    }

    isolated remote function unaryCall2Context('any:Any|'any:ContextAny req) returns 'any:ContextAny|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("AnyTypeServer/unaryCall2", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <'any:Any>result, headers: respHeaders};
    }

    isolated remote function unaryCall3('any:Any|'any:ContextAny req) returns 'any:Any|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("AnyTypeServer/unaryCall3", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <'any:Any>result;
    }

    isolated remote function unaryCall3Context('any:Any|'any:ContextAny req) returns 'any:ContextAny|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("AnyTypeServer/unaryCall3", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <'any:Any>result, headers: respHeaders};
    }

    isolated remote function clientStreamingCall() returns ClientStreamingCallStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("AnyTypeServer/clientStreamingCall");
        return new ClientStreamingCallStreamingClient(sClient);
    }

    isolated remote function serverStreamingCall('any:Any|'any:ContextAny req) returns stream<'any:Any, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("AnyTypeServer/serverStreamingCall", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        sany:AnyStream outputStream = new sany:AnyStream(result);
        return new stream<'any:Any, grpc:Error?>(outputStream);
    }

    isolated remote function serverStreamingCallContext('any:Any|'any:ContextAny req) returns 'any:ContextAnyStream|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("AnyTypeServer/serverStreamingCall", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        sany:AnyStream outputStream = new sany:AnyStream(result);
        return {content: new stream<'any:Any, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectionalStreamingCall() returns BidirectionalStreamingCallStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("AnyTypeServer/bidirectionalStreamingCall");
        return new BidirectionalStreamingCallStreamingClient(sClient);
    }
}

public client class ClientStreamingCallStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendAny('any:Any message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextAny('any:ContextAny message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveAny() returns 'any:Any|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <'any:Any>payload;
        }
    }

    isolated remote function receiveContextAny() returns 'any:ContextAny|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <'any:Any>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class BidirectionalStreamingCallStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendAny('any:Any message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextAny('any:ContextAny message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveAny() returns 'any:Any|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <'any:Any>payload;
        }
    }

    isolated remote function receiveContextAny() returns 'any:ContextAny|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <'any:Any>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class AnyTypeServerAnyCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAny('any:Any response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAny('any:ContextAny response) returns grpc:Error? {
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

public type Person1 record {|
    string name = "";
    int code = 0;
|};

public type Person2 record {|
    string name = "";
    int code = 0;
    string add = "";
|};

const string ROOT_DESCRIPTOR_ANY = "0A09616E792E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F22310A07506572736F6E3112120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646522430A07506572736F6E3212120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512100A03616464180320012809520361646432A1030A0D416E7954797065536572766572123A0A0A756E61727943616C6C3112142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E792200123A0A0A756E61727943616C6C3212142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E792200123A0A0A756E61727943616C6C3312142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E79220012450A1373657276657253747265616D696E6743616C6C12142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E792200300112450A13636C69656E7453747265616D696E6743616C6C12142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E7922002801124E0A1A6269646972656374696F6E616C53747265616D696E6743616C6C12142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E79220028013001620670726F746F33";

public isolated function getDescriptorMapAny() returns map<string> {
    return {"any.proto": "0A09616E792E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F22310A07506572736F6E3112120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646522430A07506572736F6E3212120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512100A03616464180320012809520361646432A1030A0D416E7954797065536572766572123A0A0A756E61727943616C6C3112142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E792200123A0A0A756E61727943616C6C3212142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E792200123A0A0A756E61727943616C6C3312142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E79220012450A1373657276657253747265616D696E6743616C6C12142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E792200300112450A13636C69656E7453747265616D696E6743616C6C12142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E7922002801124E0A1A6269646972656374696F6E616C53747265616D696E6743616C6C12142E676F6F676C652E70726F746F6275662E416E791A142E676F6F676C652E70726F746F6275662E416E79220028013001620670726F746F33", "google/protobuf/any.proto": "0A19676F6F676C652F70726F746F6275662F616E792E70726F746F120F676F6F676C652E70726F746F62756622360A03416E7912190A08747970655F75726C18012001280952077479706555726C12140A0576616C756518022001280C520576616C7565424F0A13636F6D2E676F6F676C652E70726F746F6275664208416E7950726F746F50015A057479706573A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

