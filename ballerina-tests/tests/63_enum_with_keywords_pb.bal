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

public isolated client class MessageServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_ENUMWITHKEYWORDS, getDescriptorMapEnumWithKeywords());
    }

    isolated remote function UnaryCall(MessageInfo|ContextMessageInfo req) returns MessageState|grpc:Error {
        map<string|string[]> headers = {};
        MessageInfo message;
        if req is ContextMessageInfo {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MessageService/UnaryCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <MessageState>result;
    }

    isolated remote function UnaryCallContext(MessageInfo|ContextMessageInfo req) returns ContextMessageState|grpc:Error {
        map<string|string[]> headers = {};
        MessageInfo message;
        if req is ContextMessageInfo {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MessageService/UnaryCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <MessageState>result, headers: respHeaders};
    }
}

public client class MessageServiceMessageStateCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendMessageState(MessageState response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextMessageState(ContextMessageState response) returns grpc:Error? {
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

public type ContextMessageState record {|
    MessageState content;
    map<string|string[]> headers;
|};

public type ContextMessageInfo record {|
    MessageInfo content;
    map<string|string[]> headers;
|};

public type MessageState record {|
    MessageState_State state = UNDEFINED;
|};

public enum MessageState_State {
    UNDEFINED,
    NEW,
    ERROR
}

public type MessageInfo record {|
    string id = "";
    string 'new = "";
|};

const string ROOT_DESCRIPTOR_ENUMWITHKEYWORDS = "0A16656E756D576974684B6579776F7264732E70726F746F222F0A0B4D657373616765496E666F120E0A0269641801200128095202696412100A036E657718022001280952036E657722650A0C4D657373616765537461746512290A05737461746518022001280E32132E4D65737361676553746174652E537461746552057374617465222A0A055374617465120D0A09554E444546494E4544100012070A034E4557100112090A054552524F521003323A0A0E4D6573736167655365727669636512280A09556E61727943616C6C120C2E4D657373616765496E666F1A0D2E4D6573736167655374617465620670726F746F33";

public isolated function getDescriptorMapEnumWithKeywords() returns map<string> {
    return {"enumWithKeywords.proto": "0A16656E756D576974684B6579776F7264732E70726F746F222F0A0B4D657373616765496E666F120E0A0269641801200128095202696412100A036E657718022001280952036E657722650A0C4D657373616765537461746512290A05737461746518022001280E32132E4D65737361676553746174652E537461746552057374617465222A0A055374617465120D0A09554E444546494E4544100012070A034E4557100112090A054552524F521003323A0A0E4D6573736167655365727669636512280A09556E61727943616C6C120C2E4D657373616765496E666F1A0D2E4D6573736167655374617465620670726F746F33"};
}

