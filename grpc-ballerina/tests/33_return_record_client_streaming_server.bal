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

import ballerina/io;

listener Listener ep33 = new (9123);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_33,
    descMap: getDescriptorMap33()
}
service "HelloWorld33" on ep33 {
    remote isolated function sayHello(stream<SampleMsg33, error?> clientStream) returns ContextSampleMsg33 {
        io:println("Connected sucessfully.");
        error? e = clientStream.forEach(isolated function(SampleMsg33 val) {
            io:println(val);
        });
        if (e is ()) {
            SampleMsg33 response = {name: "WSO2", id: 1};
            return {content: response, headers: {zzz: "yyy"}};
        } else {
            SampleMsg33 errResponse = {name: "", id: 0};
            return {content: errResponse, headers: {zzz: "yyy"}};
        }
    }
}

public client class HelloWorld33SampleMsg33Caller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSampleMsg33(SampleMsg33 response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public type SampleMsg33 record {|
    string name = "";
    int id = 0;
|};

public type ContextSampleMsg33 record {|
    SampleMsg33 content;
    map<string|string[]> headers;
|};



const string ROOT_DESCRIPTOR_33 = "0A2733335F72657475726E5F7265636F72645F636C69656E745F73747265616D696E672E70726F746F22310A0B53616D706C654D7367333312120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432380A0C48656C6C6F576F726C64333312280A0873617948656C6C6F120C2E53616D706C654D736733331A0C2E53616D706C654D736733332801620670726F746F33";
isolated function getDescriptorMap33() returns map<string> {
    return {
        "33_return_record_client_streaming.proto":"0A2733335F72657475726E5F7265636F72645F636C69656E745F73747265616D696E672E70726F746F22310A0B53616D706C654D7367333312120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432380A0C48656C6C6F576F726C64333312280A0873617948656C6C6F120C2E53616D706C654D736733331A0C2E53616D706C654D736733332801620670726F746F33"

    };
}

