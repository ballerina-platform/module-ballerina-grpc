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
    StreamCallStreamingClient streamingClient = check ep->StreamCall();
    check streamingClient->sendStreamCallRequest({phone_number: phoneNumber});
    check streamingClient->complete();
    check call(streamingClient);

    if waitPeer(phoneNumber) {
        audioSession();
    }
    log:printInfo("Call finished");
}

function call(StreamCallStreamingClient streamCall) returns error? {
    @strand {thread: "any"}
    worker Caller returns error? {
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
}

function audioSession() {
    if media != "" {
        log:printInfo(string `Consuming audio resource [${media}]`);
    }
    while !isFinished() {
    }
    log:printInfo(string `Audio session finished [${media}]`);
}

function waitPeer(string phoneNumber) returns boolean {
    @strand {thread: "any"}
    worker Streamer returns boolean {
        log:printInfo(string `Waiting for peer to connect [${phoneNumber}]...`);
        while !isResponded() {
        }
        return callState == ACTIVE;
    }
    return wait Streamer;
}

function isResponded() returns boolean {
    lock {
        return peerResponded;
    }
}

function isFinished() returns boolean {
    lock {
        return callFinished;
    }
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
