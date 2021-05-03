// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

int TIMEOUT = 5000;
int requestCount = 0;

string clientName = "";

listener Listener retryListener = new (9112);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_22,
    descMap: getDescriptorMap22()
}
service "RetryService" on retryListener {
    remote function getResult(RetryServiceStringCaller caller, string value) {
        // Identifying the client to maintain state to track retry attempts.
        if (clientName != value) {
            requestCount = 0;
            clientName = <@untainted>value;
        }
        requestCount += 1;
        io:println(clientName + ": Attetmpt No. " + requestCount.toString());
        if (requestCount < 4) {
            error? sendResult = caller->sendError(error InternalError("Mocking Internal Error"));
            error? completeResult = caller->complete();
        } else {
            error? sendResult = caller->sendString("Total Attempts: " + requestCount.toString());
            error? completeResult = caller->complete();
        }
    }
}
