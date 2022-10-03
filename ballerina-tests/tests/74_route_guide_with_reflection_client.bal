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

import ballerina/test;

@test:Config {enable: true}
function testListServicesReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9174");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9174", list_services: ""});
    check streamingClient->complete();
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host":"http://localhost:9174",
        "original_request": {
            "host":"http://localhost:9174",
            "list_services":""
        },
        "list_services_response": {
            "service": [{"name":"routeguide.RouteGuide"}, {"name":"grpc.reflection.v1alpha.ServerReflection"}]
        }
    });
}

@test:Config {enable: true}
function testFileByFilenameReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9174");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9174", file_by_filename: "google/protobuf/wrappers.proto"});
    check streamingClient->complete();
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9174",
        "original_request": {
            "host": "http://localhost:9174",
            "file_by_filename": "google/protobuf/wrappers.proto"
        },
        "file_descriptor_response": {
            "file_descriptor_proto": [10,30,103,111,111,103,108,101,47,112,114,111,116,111,98,117,102,47,119,114,97,112,
                112,101,114,115,46,112,114,111,116,111,18,15,103,111,111,103,108,101,46,112,114,111,116,111,98,117,102,
                34,28,10,11,68,111,117,98,108,101,86,97,108,117,101,18,13,10,5,118,97,108,117,101,24,1,32,1,40,1,34,27,
                10,10,70,108,111,97,116,86,97,108,117,101,18,13,10,5,118,97,108,117,101,24,1,32,1,40,2,34,27,10,10,73,
                110,116,54,52,86,97,108,117,101,18,13,10,5,118,97,108,117,101,24,1,32,1,40,3,34,28,10,11,85,73,110,116,
                54,52,86,97,108,117,101,18,13,10,5,118,97,108,117,101,24,1,32,1,40,4,34,27,10,10,73,110,116,51,50,86,97,
                108,117,101,18,13,10,5,118,97,108,117,101,24,1,32,1,40,5,34,28,10,11,85,73,110,116,51,50,86,97,108,117,
                101,18,13,10,5,118,97,108,117,101,24,1,32,1,40,13,34,26,10,9,66,111,111,108,86,97,108,117,101,18,13,10,
                5,118,97,108,117,101,24,1,32,1,40,8,34,28,10,11,83,116,114,105,110,103,86,97,108,117,101,18,13,10,5,118,
                97,108,117,101,24,1,32,1,40,9,34,27,10,10,66,121,116,101,115,86,97,108,117,101,18,13,10,5,118,97,108,117,
                101,24,1,32,1,40,12,66,131,1,10,19,99,111,109,46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,
                102,66,13,87,114,97,112,112,101,114,115,80,114,111,116,111,80,1,90,49,103,111,111,103,108,101,46,103,111,
                108,97,110,103,46,111,114,103,47,112,114,111,116,111,98,117,102,47,116,121,112,101,115,47,107,110,111,
                119,110,47,119,114,97,112,112,101,114,115,112,98,248,1,1,162,2,3,71,80,66,170,2,30,71,111,111,103,108,
                101,46,80,114,111,116,111,98,117,102,46,87,101,108,108,75,110,111,119,110,84,121,112,101,115,98,6,112,
                114,111,116,111,51]
        }
    });
}
