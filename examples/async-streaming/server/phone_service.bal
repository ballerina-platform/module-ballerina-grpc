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
import ballerina/lang.runtime;
import ballerina/grpc;

configurable int port = 8981;
int counter = 0;
const string MEDIA = "https://link.to.audio.resources";

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_PHONE, descMap: getDescriptorMapPhone()}
service "Phone" on new grpc:Listener(port) {

    remote function StreamCall(PhoneStreamCallResponseCaller caller, stream<StreamCallRequest, grpc:Error?> clientStream) returns error? {
        _ = check clientStream.forEach(function(StreamCallRequest callReq) {

            // Send call state NEW
            log:printInfo(string `Received a phone call request for number ${callReq.phone_number}`);
            runtime:sleep(1);
            checkpanic caller->sendStreamCallResponse({call_state: {state: 'NEW}});

            int sessionId = 0;
            lock {
                sessionId = counter;
                counter += 1;
            }

            // Send call info
            runtime:sleep(1);
            log:printInfo(string `Created a call session => session ID: ${sessionId}, media: ${MEDIA}`);
            CallInfo callInfo = {session_id: sessionId.toString(), media: MEDIA};
            checkpanic caller->sendStreamCallResponse({call_info: callInfo});

            checkpanic caller->sendStreamCallResponse({call_state: {state: ACTIVE}});
            runtime:sleep(1);
            checkpanic caller->sendStreamCallResponse({call_state: {state: ENDED}});
            log:printInfo(string `Call finished [${callReq.phone_number}]`);

            // Clean the call session
            cleanCallSession(callInfo);
            checkpanic caller->complete();
        });
    }
}

isolated function cleanCallSession(CallInfo info) {
    log:printInfo(string `Call session cleaned => session ID: ${info.session_id}, media: ${info.media}`);
}

