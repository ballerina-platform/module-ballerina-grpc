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
import ballerina/test;

@test:Config
function testSimpleServiceWithAnnotation() returns error? {
    SimpleServiceWithAnnotationClient annotClient = check new ("http://localhost:9167");

    SimpleResponseWithAnnotation unaryResponse = check annotClient->unaryCallWithAnnotatedData({name: "Request 01"});
    test:assertEquals(unaryResponse, <SimpleResponseWithAnnotation>{name: "Response 01"});

    stream<SimpleResponseWithAnnotation, grpc:Error?> serverStreamResponse = check annotClient->serverStreamingWithAnnotatedData({name: "Request 01"});
    SimpleResponseWithAnnotation[] streamingResponses = [
        {name: "Response 01"},
        {name: "Response 02"},
        {name: "Response 03"}
    ];
    int i = 0;
    check serverStreamResponse.forEach(function(SimpleResponseWithAnnotation streamingResponse) {
        test:assertEquals(streamingResponse, streamingResponses[i]);
        i += 1;
    });
    test:assertEquals(i, 3);

    SimpleRequestWithAnnotation[] streamingRequests = [
        {name: "Response 01"},
        {name: "Response 02"},
        {name: "Response 03"}
    ];
    ClientStreamingWithAnnotatedDataStreamingClient clientStreamingStreamingClient = check annotClient->clientStreamingWithAnnotatedData();
    foreach SimpleRequestWithAnnotation req in streamingRequests {
        check clientStreamingStreamingClient->sendSimpleRequestWithAnnotation(req);
    }
    check clientStreamingStreamingClient->complete();
    SimpleResponseWithAnnotation? clientStreamingResponse = check clientStreamingStreamingClient->receiveSimpleResponseWithAnnotation();
    test:assertEquals(clientStreamingResponse, <SimpleResponseWithAnnotation>{name: "Response"});

    BidirectionalStreamingWithAnnotatedDataStreamingClient bidirectionalStreamingStreamingClient = check annotClient->bidirectionalStreamingWithAnnotatedData();
    foreach SimpleRequestWithAnnotation req in streamingRequests {
        i += 1;
        check bidirectionalStreamingStreamingClient->sendSimpleRequestWithAnnotation(req);
    }

    check bidirectionalStreamingStreamingClient->complete();
    i = 0;
    SimpleResponseWithAnnotation? bidiStreamingResponse = check bidirectionalStreamingStreamingClient->receiveSimpleResponseWithAnnotation();
    test:assertEquals(<SimpleResponseWithAnnotation>bidiStreamingResponse, streamingResponses[i]);
    i += 1;
    while !(bidiStreamingResponse is ()) {
        bidiStreamingResponse = check bidirectionalStreamingStreamingClient->receiveSimpleResponseWithAnnotation();
        if bidiStreamingResponse is SimpleResponseWithAnnotation {
            test:assertEquals(<SimpleResponseWithAnnotation>bidiStreamingResponse, streamingResponses[i]);
            i += 1;
        }
    }
    test:assertEquals(i, 3);
}

