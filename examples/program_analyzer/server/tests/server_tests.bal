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

import ballerina/lang.value;
import ballerina/test;

@test:Config{}
isolated function testCompression() returns error? {
    BalProgramAnalyzerClient ep = check new ("http://localhost:9090", maxInboundMessageSize = 424193);
    string s = check ep->syntaxTree();
    json j = check value:fromJsonString(s);
    test:assertEquals(j.ballerinaVersion, "2201.0.0-20220106-161300-2509bf6c");
}

