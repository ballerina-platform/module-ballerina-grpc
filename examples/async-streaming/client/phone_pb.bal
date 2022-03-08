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

public isolated client class PhoneClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_PHONE, getDescriptorMapPhone());
    }

    isolated remote function StreamCall() returns StreamCallStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("grpc.testing.Phone/StreamCall");
        return new StreamCallStreamingClient(sClient);
    }
}

public client class StreamCallStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStreamCallRequest(StreamCallRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStreamCallRequest(ContextStreamCallRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStreamCallResponse() returns StreamCallResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <StreamCallResponse>payload;
        }
    }

    isolated remote function receiveContextStreamCallResponse() returns ContextStreamCallResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <StreamCallResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class PhoneStreamCallResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStreamCallResponse(StreamCallResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStreamCallResponse(ContextStreamCallResponse response) returns grpc:Error? {
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

public type ContextStreamCallResponseStream record {|
    stream<StreamCallResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextStreamCallRequestStream record {|
    stream<StreamCallRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextStreamCallResponse record {|
    StreamCallResponse content;
    map<string|string[]> headers;
|};

public type ContextStreamCallRequest record {|
    StreamCallRequest content;
    map<string|string[]> headers;
|};

public type StreamCallResponse record {|
    CallInfo call_info?;
    CallState call_state?;
|};

isolated function isValidStreamcallresponse(StreamCallResponse r) returns boolean {
    int stream_call_responseCount = 0;
    if !(r?.call_info is ()) {
        stream_call_responseCount += 1;
    }
    if !(r?.call_state is ()) {
        stream_call_responseCount += 1;
    }
    if (stream_call_responseCount > 1) {
        return false;
    }
    return true;
}

isolated function setStreamCallResponse_CallInfo(StreamCallResponse r, CallInfo call_info) {
    r.call_info = call_info;
    _ = r.removeIfHasKey("call_state");
}

isolated function setStreamCallResponse_CallState(StreamCallResponse r, CallState call_state) {
    r.call_state = call_state;
    _ = r.removeIfHasKey("call_info");
}

public type CallInfo record {|
    string session_id = "";
    string media = "";
|};

public type CallState record {|
    CallState_State state = UNDEFINED;
|};

public enum CallState_State {
    UNDEFINED,
    'NEW,
    ACTIVE,
    ENDED
}

public type StreamCallRequest record {|
    string phone_number = "";
|};

const string ROOT_DESCRIPTOR_PHONE = "0A0B70686F6E652E70726F746F120C677270632E74657374696E67223F0A0843616C6C496E666F121D0A0A73657373696F6E5F6964180120012809520973657373696F6E496412140A056D6564696118022001280952056D6564696122780A0943616C6C537461746512330A05737461746518022001280E321D2E677270632E74657374696E672E43616C6C53746174652E53746174655205737461746522360A055374617465120D0A09554E444546494E4544100012070A034E45571001120A0A06414354495645100612090A05454E444544100722360A1153747265616D43616C6C5265717565737412210A0C70686F6E655F6E756D626572180120012809520B70686F6E654E756D626572229D010A1253747265616D43616C6C526573706F6E736512350A0963616C6C5F696E666F18012001280B32162E677270632E74657374696E672E43616C6C496E666F4800520863616C6C496E666F12380A0A63616C6C5F737461746518022001280B32172E677270632E74657374696E672E43616C6C53746174654800520963616C6C537461746542160A1473747265616D5F63616C6C5F726573706F6E7365325C0A0550686F6E6512530A0A53747265616D43616C6C121F2E677270632E74657374696E672E53747265616D43616C6C526571756573741A202E677270632E74657374696E672E53747265616D43616C6C526573706F6E736528013001620670726F746F33";

public isolated function getDescriptorMapPhone() returns map<string> {
    return {"phone.proto": "0A0B70686F6E652E70726F746F120C677270632E74657374696E67223F0A0843616C6C496E666F121D0A0A73657373696F6E5F6964180120012809520973657373696F6E496412140A056D6564696118022001280952056D6564696122780A0943616C6C537461746512330A05737461746518022001280E321D2E677270632E74657374696E672E43616C6C53746174652E53746174655205737461746522360A055374617465120D0A09554E444546494E4544100012070A034E45571001120A0A06414354495645100612090A05454E444544100722360A1153747265616D43616C6C5265717565737412210A0C70686F6E655F6E756D626572180120012809520B70686F6E654E756D626572229D010A1253747265616D43616C6C526573706F6E736512350A0963616C6C5F696E666F18012001280B32162E677270632E74657374696E672E43616C6C496E666F4800520863616C6C496E666F12380A0A63616C6C5F737461746518022001280B32172E677270632E74657374696E672E43616C6C53746174654800520963616C6C537461746542160A1473747265616D5F63616C6C5F726573706F6E7365325C0A0550686F6E6512530A0A53747265616D43616C6C121F2E677270632E74657374696E672E53747265616D43616C6C526571756573741A202E677270632E74657374696E672E53747265616D43616C6C526573706F6E736528013001620670726F746F33"};
}

