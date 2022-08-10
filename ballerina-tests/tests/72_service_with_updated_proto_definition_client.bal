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
        UpdatedServiceClient cc = check new("http://localhost:9172");
        GetClassResponse res = check cc->GetClass({class_name: "13-A"});
        io:println(res);
        test:assertEquals(res, {
            class_data: {
                number: 120,
                location: "galle",
                leader: "Charlie",
                name: "13-A"
            },
            has_teacher: true
        });
    }
}

@test:Config {enable: true}
function testServiceWithUpdatedProtoDefinitionWithStructAndOneOfField() returns error? {
    if !isWindowsEnvironment() {
        UpdatedServiceClient cc = check new("http://localhost:9172");
        Group res = check cc->GetGroup();
        io:println(res);
        test:assertEquals(res, {
            g_number: 120,
            g_name: "ABC",
            g_id: "g_abc",
            description: "This is ABC Group",
            first_group: true,
            name: "ABC",
            other_data: {
                "count": "5",
                "names": ["A", "B", "C", "D"],
                "marks": 100.0
            }
        });
    }
}
