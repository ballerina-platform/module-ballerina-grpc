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

import ballerina/log;

PhoneClient ep = check new ("http://localhost:8981");
boolean peerResponded = false;
boolean callFinished = false;
CallState_State callState = UNDEFINED;
string phoneNumber = "94771234567";
string sessionId = "";
string media = "";

public function main() returns error? {
    StreamCallStreamingClient streamCall = check ep->StreamCall();
    worker Caller returns error? {
        if waitPeer(phoneNumber) {
            audioSession();
        }
        [peerResponded, callFinished] = check <- CallStatusChecker;
    }
    worker CallStatusChecker returns [boolean, boolean]|error {
        check streamCall->sendStreamCallRequest({phone_number: phoneNumber});
        check streamCall->complete();
        check call(streamCall);
        [peerResponded, callFinished] -> Caller;
        return [peerResponded, callFinished];
    }
}

function call(StreamCallStreamingClient streamCall) returns error? {
    StreamCallResponse? response = check streamCall->receiveStreamCallResponse();
    while response != () {
        if response?.call_info is CallInfo {
            CallInfo callInfo = <CallInfo>response?.call_info;
            sessionId = callInfo.session_id;
            media = callInfo.media;
        } else if response?.call_state is CallState {
            CallState currentState = <CallState>(response?.call_state);
            callState = currentState.state;
            onCallState(phoneNumber);
        }
        response = check streamCall->receiveStreamCallResponse();
    }
}

function audioSession() {
    if media != "" {
        log:printInfo(string `Consuming audio resource [${media}]`);
    }
    while !callFinished {
    }
    log:printInfo(string `Audio session finished [${media}]`);
}

function waitPeer(string phoneNumber) returns boolean {
    log:printInfo(string `Waiting for peer to connect [${phoneNumber}]...`);
    while !peerResponded {
        log:printInfo(string `wait peer ${peerResponded}`);
    }
    return callState == ACTIVE;
}

function onCallState(string phoneNumber) {
    log:printInfo(string `Call toward [${phoneNumber}] enters [${callState.toBalString()}] state`);
    if callState == ACTIVE {
        lock {
            peerResponded = true;
        }

    } else if callState is ENDED {
        lock {
            peerResponded = true;
            callFinished = true;
        }
    }
}
