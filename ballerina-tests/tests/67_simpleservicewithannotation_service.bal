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
import ballerina/io;
import ballerina/grpc;

 public function main() returns error? {
    SimpleServiceWithAnnotationClient annotClient = check new ("http://localhost:9090");

     SimpleResponseWithAnnotation unaryResponse = check annotClient->unary({name: "Request 01"});
     io:println(unaryResponse);

     stream<SimpleResponseWithAnnotation, grpc:Error?> serverStreamResponse = check annotClient->serverStreaming({name: "Request 01"});
     SimpleResponseWithAnnotation[] streamingResponses = [
             {name: "Response 01"},
             {name: "Response 02"},
             {name: "Response 03"}
         ];
     int i = 0;
     check serverStreamResponse.forEach(function (SimpleResponseWithAnnotation streamingResponse) {
         io:println(streamingResponse);
         i += 1;
     });
     io:println(i);

    //SimpleRequestWithAnnotation[] streamingRequests = [
    //        {name: "Response 01"}
    //    ];
    //ClientStreamingStreamingClient clientStreamingStreamingClient = check annotClient->clientStreaming();
    //foreach SimpleRequestWithAnnotation req in streamingRequests {
    //    check clientStreamingStreamingClient->sendSimpleRequestWithAnnotation(req);
    //}
    //check clientStreamingStreamingClient->complete();
    //SimpleResponseWithAnnotation? clientStreamingResponse = check clientStreamingStreamingClient->receiveSimpleResponseWithAnnotation();
    //io:println(clientStreamingResponse);

}