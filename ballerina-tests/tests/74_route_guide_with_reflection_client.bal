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
function testRouteGuideListServicesReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9144");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9144", list_services: ""});
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host":"http://localhost:9144",
        "original_request": {
            "host":"http://localhost:9144",
            "list_services":""
        },
        "list_services_response": {
            "service": [{"name":"routeguide.RouteGuide"}, {"name":"grpc.reflection.v1alpha.ServerReflection"}]
        }
    });
    check streamingClient->complete();
}

@test:Config {enable: true}
function testRouteGuideFileByFilenameReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9144");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9144", file_by_filename: "google/protobuf/wrappers.proto"});
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9144",
        "original_request": {
            "host": "http://localhost:9144",
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
    check streamingClient->complete();
}

@test:Config {enable: true}
function testRouteGuideFileContainingSymbolReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9144");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9144", file_containing_symbol: "routeguide.RouteGuide"});
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9144",
        "original_request": {
            "host": "http://localhost:9144",
            "file_containing_symbol": "routeguide.RouteGuide"
        },
        "file_descriptor_response": {
            "file_descriptor_proto": [10,20,52,52,95,114,111,117,116,101,95,103,117,105,100,101,46,112,114,111,116,111,
            18,10,114,111,117,116,101,103,117,105,100,101,34,65,10,5,80,111,105,110,116,18,26,10,8,108,97,116,105,116,
            117,100,101,24,1,32,1,40,5,82,8,108,97,116,105,116,117,100,101,18,28,10,9,108,111,110,103,105,116,117,100,
            101,24,2,32,1,40,5,82,9,108,111,110,103,105,116,117,100,101,34,81,10,9,82,101,99,116,97,110,103,108,101,18,
            33,10,2,108,111,24,1,32,1,40,11,50,17,46,114,111,117,116,101,103,117,105,100,101,46,80,111,105,110,116,82,2,
            108,111,18,33,10,2,104,105,24,2,32,1,40,11,50,17,46,114,111,117,116,101,103,117,105,100,101,46,80,111,105,
            110,116,82,2,104,105,34,76,10,7,70,101,97,116,117,114,101,18,18,10,4,110,97,109,101,24,1,32,1,40,9,82,4,110,
            97,109,101,18,45,10,8,108,111,99,97,116,105,111,110,24,2,32,1,40,11,50,17,46,114,111,117,116,101,103,117,105,
            100,101,46,80,111,105,110,116,82,8,108,111,99,97,116,105,111,110,34,84,10,9,82,111,117,116,101,78,111,116,
            101,18,45,10,8,108,111,99,97,116,105,111,110,24,1,32,1,40,11,50,17,46,114,111,117,116,101,103,117,105,100,
            101,46,80,111,105,110,116,82,8,108,111,99,97,116,105,111,110,18,24,10,7,109,101,115,115,97,103,101,24,2,32,
            1,40,9,82,7,109,101,115,115,97,103,101,34,147,1,10,12,82,111,117,116,101,83,117,109,109,97,114,121,18,31,10,
            11,112,111,105,110,116,95,99,111,117,110,116,24,1,32,1,40,5,82,10,112,111,105,110,116,67,111,117,110,116,18,
            35,10,13,102,101,97,116,117,114,101,95,99,111,117,110,116,24,2,32,1,40,5,82,12,102,101,97,116,117,114,101,
            67,111,117,110,116,18,26,10,8,100,105,115,116,97,110,99,101,24,3,32,1,40,5,82,8,100,105,115,116,97,110,99,
            101,18,33,10,12,101,108,97,112,115,101,100,95,116,105,109,101,24,4,32,1,40,5,82,11,101,108,97,112,115,101,
            100,84,105,109,101,50,133,2,10,10,82,111,117,116,101,71,117,105,100,101,18,54,10,10,71,101,116,70,101,97,
            116,117,114,101,18,17,46,114,111,117,116,101,103,117,105,100,101,46,80,111,105,110,116,26,19,46,114,111,117,
            116,101,103,117,105,100,101,46,70,101,97,116,117,114,101,34,0,18,62,10,12,76,105,115,116,70,101,97,116,117,
            114,101,115,18,21,46,114,111,117,116,101,103,117,105,100,101,46,82,101,99,116,97,110,103,108,101,26,19,46,
            114,111,117,116,101,103,117,105,100,101,46,70,101,97,116,117,114,101,34,0,48,1,18,62,10,11,82,101,99,111,
            114,100,82,111,117,116,101,18,17,46,114,111,117,116,101,103,117,105,100,101,46,80,111,105,110,116,26,24,46,
            114,111,117,116,101,103,117,105,100,101,46,82,111,117,116,101,83,117,109,109,97,114,121,34,0,40,1,18,63,10,
            9,82,111,117,116,101,67,104,97,116,18,21,46,114,111,117,116,101,103,117,105,100,101,46,82,111,117,116,101,
            78,111,116,101,26,21,46,114,111,117,116,101,103,117,105,100,101,46,82,111,117,116,101,78,111,116,101,34,0,
            40,1,48,1,66,104,10,27,105,111,46,103,114,112,99,46,101,120,97,109,112,108,101,115,46,114,111,117,116,101,
            103,117,105,100,101,66,15,82,111,117,116,101,71,117,105,100,101,80,114,111,116,111,80,1,90,54,103,111,111,
            103,108,101,46,103,111,108,97,110,103,46,111,114,103,47,103,114,112,99,47,101,120,97,109,112,108,101,115,47,
            114,111,117,116,101,95,103,117,105,100,101,47,114,111,117,116,101,103,117,105,100,101,98,6,112,114,111,116,
            111,51]
        }
    });
    check streamingClient->complete();
}

@test:Config {enable: true}
function testRouteGuideFileContainingUnknownSymbolReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9144");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9144", file_containing_symbol: "package.UnknownPackage"});
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9144",
        "original_request": {
            "host": "http://localhost:9144",
            "file_containing_symbol": "package.UnknownPackage"
        },
        "error_response": {
            "error_code": 5,
            "error_message": "package.UnknownPackage symbol not found"
        }
    });
    check streamingClient->complete();
}
