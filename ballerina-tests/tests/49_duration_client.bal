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
import ballerina/test;
import ballerina/time;

@test:Config {}
function testDurationUnaryCall1() returns grpc:Error? {
    DurationHandlerClient ep = check new ("http://localhost:9149");
    time:Seconds msg = check ep->unaryCall1("call1");
    test:assertEquals(msg, 12.34d);
}

@test:Config {}
function testDurationUnaryCall2() returns grpc:Error? {
    DurationHandlerClient ep = check new ("http://localhost:9149");
    DurationMsg reqMsg = {name: "duration 01", duration: 1.11d};
    DurationMsg resMsg = check ep->unaryCall2(reqMsg);
    test:assertEquals(resMsg, reqMsg);
}

@test:Config {}
function testDurationServerStreaming() returns error? {
    DurationHandlerClient ep = check new ("http://localhost:9149");
    stream<time:Seconds, error?> durationStream = check ep->serverStreaming("server streaming with duration");
    time:Seconds[] expectedDurations = [1.11d, 2.22d, 3.33d, 4.44d];
    int i = 0;
    check durationStream.forEach(function(time:Seconds d) {
        test:assertEquals(d, expectedDurations[i]);
        i += 1;
    });
    test:assertEquals(i, 4);
}

@test:Config {}
function testDurationClientStreaming() returns grpc:Error? {
    DurationHandlerClient ep = check new ("http://localhost:9149");
    time:Seconds[] durations = [1.11d, 2.22d, 3.33d, 4.44d];
    ClientStreamingStreamingClient sc = check ep->clientStreaming();
    foreach time:Seconds d in durations {
        check sc->sendDuration(d);
    }
    check sc->complete();
    string? ack = check sc->receiveString();
    test:assertTrue(ack is string);
    test:assertEquals(<string>ack, "Ack");

}

@test:Config {enable: true}
function testDurationBidirectionalStreaming() returns grpc:Error? {
    DurationHandlerClient ep = check new ("http://localhost:9149");
    DurationMsg[] durationMessages = [
        {name: "duration 01", duration: 1.11d},
        {name: "duration 02", duration: 2.22d},
        {name: "duration 03", duration: 3.33d},
        {name: "duration 04", duration: 4.44d}
    ];
    BidirectionalStreamingStreamingClient sc = check ep->bidirectionalStreaming();
    foreach DurationMsg dm in durationMessages {
        check sc->sendDurationMsg(dm);
    }
    check sc->complete();
    int i = 0;
    DurationMsg? response = check sc->receiveDurationMsg();
    if response is DurationMsg {
        test:assertEquals(response, durationMessages[i]);
        i += 1;
    }
    while !(response is ()) {
        response = check sc->receiveDurationMsg();
        if response is DurationMsg {
            test:assertEquals(response, durationMessages[i]);
            i += 1;
        }
    }
    test:assertEquals(i, 4);
}

