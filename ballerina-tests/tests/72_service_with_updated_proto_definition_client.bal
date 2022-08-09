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
import ballerina/test;

// Related service definition can be found in https://github.com/dilanSachi/grpc-ballerina-docker-service
// and the docker container can be found in https://hub.docker.com/r/dilansachi/grpc_ballerina_docker_service
@test:Config {enable: true}
function testServiceWithUpdatedProtoDefinition() returns error? {
    if !isWindowsEnvironment() {
        UserServiceClient cc = check new("http://localhost:9172");
        GetOrganizationResponse res = check cc->GetOrganization({organization_name: "Ballerina"});
        io:println(res);
        test:assertEquals(res, {
            organization: {
                id: 120,
                uuid: "6c3239ef",
                'handle: "ballerina",
                name: "Ballerina User"
            },
            is_admin: true
        });
    }
}

@test:Config {enable: true}
function testServiceWithUpdatedProtoDefinitionWithStructAndOneOfField() returns error? {
    if !isWindowsEnvironment() {
        UserServiceClient cc = check new("http://localhost:9172");
        Group res = check cc->GetGroup();
        io:println(res);
        test:assertEquals(res, {
            id: 120,
            org_name: "Ballerina",
            org_uuid: "bal_swan_lake",
            description: "This is Ballerina gRPC",
            default_group: true,
            other_data: {
                "version": "2.3.1",
                "release_data": [12.0, 13.0],
                "artifact_count": 100.0
            },
            name: "gRPC"
        });
    }
}
