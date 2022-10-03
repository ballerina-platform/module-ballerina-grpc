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
function testPackagingListServicesReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9171");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9171", list_services: ""});
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host":"http://localhost:9171",
        "original_request": {
            "host":"http://localhost:9171",
            "list_services":""
        },
        "list_services_response": {
            "service": [{"name":"packaging.helloWorld71"}, {"name":"grpc.reflection.v1alpha.ServerReflection"}]
        }
    });
    check streamingClient->complete();
}

@test:Config {enable: true}
function testPackagingFileByFilenameReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9171");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9171", file_by_filename: "google/protobuf/wrappers.proto"});
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9171",
        "original_request": {
            "host": "http://localhost:9171",
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
function testPackagingFileContainingSymbolReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9171");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9171", file_containing_symbol: "packaging.helloWorld71"});
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9171",
        "original_request": {
            "host": "http://localhost:9171",
            "file_containing_symbol": "packaging.helloWorld71"
        },
        "file_descriptor_response": {
            "file_descriptor_proto": [10,42,55,49,95,112,97,99,107,97,103,101,95,119,105,116,104,95,115,101,114,118,
            105,99,101,95,105,110,95,115,117,98,109,111,100,117,108,101,46,112,114,111,116,111,18,9,112,97,99,107,97,
            103,105,110,103,26,35,98,97,108,108,101,114,105,110,97,47,112,114,111,116,111,98,117,102,47,100,101,115,99,
            114,105,112,116,111,114,46,112,114,111,116,111,26,16,55,49,95,109,101,115,115,97,103,101,46,112,114,111,116,
            111,50,181,2,10,12,104,101,108,108,111,87,111,114,108,100,55,49,18,65,10,17,104,101,108,108,111,87,111,114,
            108,100,55,49,85,110,97,114,121,18,21,46,112,97,99,107,97,103,105,110,103,46,82,101,113,77,101,115,115,97,
            103,101,26,21,46,112,97,99,107,97,103,105,110,103,46,82,101,115,77,101,115,115,97,103,101,18,74,10,24,104,
            101,108,108,111,87,111,114,108,100,55,49,83,101,114,118,101,114,83,116,114,101,97,109,18,21,46,112,97,99,
            107,97,103,105,110,103,46,82,101,113,77,101,115,115,97,103,101,26,21,46,112,97,99,107,97,103,105,110,103,46,
            82,101,115,77,101,115,115,97,103,101,48,1,18,74,10,24,104,101,108,108,111,87,111,114,108,100,55,49,67,108,
            105,101,110,116,83,116,114,101,97,109,18,21,46,112,97,99,107,97,103,105,110,103,46,82,101,113,77,101,115,
            115,97,103,101,26,21,46,112,97,99,107,97,103,105,110,103,46,82,101,115,77,101,115,115,97,103,101,40,1,18,74,
            10,22,104,101,108,108,111,87,111,114,108,100,55,49,66,105,100,105,83,116,114,101,97,109,18,21,46,112,97,99,
            107,97,103,105,110,103,46,82,101,113,77,101,115,115,97,103,101,26,21,46,112,97,99,107,97,103,105,110,103,46,
            82,101,115,77,101,115,115,97,103,101,40,1,48,1,66,13,226,71,10,103,114,112,99,95,116,101,115,116,115,98,6,
            112,114,111,116,111,51]
        }
    });
    check streamingClient->complete();
}

@test:Config {enable: true}
function testPackagingFileContainingUnknownSymbolReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9171");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9171", file_containing_symbol: "package.UnknownPackage"});
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9171",
        "original_request": {
            "host": "http://localhost:9171",
            "file_containing_symbol": "package.UnknownPackage"
        },
        "error_response": {
            "error_code": 1,
            "error_message": "package.UnknownPackage symbol not found"
        }
    });
    check streamingClient->complete();
}

@test:Config {enable: true}
function testPackagingUnknownFilenameReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9171");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({host: "http://localhost:9171", file_by_filename: "unknown_file.proto"});
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9171",
        "original_request": {
            "host": "http://localhost:9171",
            "file_by_filename": "unknown_file.proto"
        },
        "error_response": {
            "error_code": 1,
            "error_message": "unknown_file.proto not found"
        }
    });
    check streamingClient->complete();
}

@test:Config {enable: true}
function testPackagingFileContainingExtensionReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9171");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({
        host: "http://localhost:9171",
        file_containing_extension: {
            containing_type: "google.protobuf.FileOptions", extension_number: 1148
        }
    });
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9171",
        "original_request": {
            "host": "http://localhost:9171",
            "file_containing_extension": {
                containing_type: "google.protobuf.FileOptions", extension_number: 1148
            }
        },
        "file_descriptor_response": {
            "file_descriptor_proto": [10,35,98,97,108,108,101,114,105,110,97,47,112,114,111,116,111,98,117,102,47,100,
            101,115,99,114,105,112,116,111,114,46,112,114,111,116,111,18,18,98,97,108,108,101,114,105,110,97,46,112,114,
            111,116,111,98,117,102,26,32,103,111,111,103,108,101,47,112,114,111,116,111,98,117,102,47,100,101,115,99,
            114,105,112,116,111,114,46,112,114,111,116,111,58,72,10,16,98,97,108,108,101,114,105,110,97,95,109,111,100,
            117,108,101,18,28,46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,102,46,70,105,108,101,79,112,116,
            105,111,110,115,24,252,8,32,1,40,9,82,15,98,97,108,108,101,114,105,110,97,77,111,100,117,108,101,98,6,112,
            114,111,116,111,51]
        }
    });
    check streamingClient->complete();
}


@test:Config {enable: true}
function testPackagingAllExtensionNumbersOfTypeReflection() returns error? {
    ServerReflectionClient reflectionClient = check new ("http://localhost:9171");
    ServerReflectionInfoStreamingClient streamingClient = check reflectionClient->ServerReflectionInfo();
    check streamingClient->sendServerReflectionRequest({
        host: "http://localhost:9171",
        all_extension_numbers_of_type: "google.protobuf.FileOptions"
    });
    ServerReflectionResponse? response = check streamingClient->receiveServerReflectionResponse();
    test:assertEquals(response, {
        "valid_host": "http://localhost:9171",
        "original_request": {
            "host": "http://localhost:9171",
            "all_extension_numbers_of_type": "google.protobuf.FileOptions"
        },
        "all_extension_numbers_response": {
            "base_type_name": "google.protobuf.FileOptions",
            "extension_number": [1148]
        }
    });
    check streamingClient->complete();
}
