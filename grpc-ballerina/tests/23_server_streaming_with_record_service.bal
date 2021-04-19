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

import ballerina/log;

listener Listener helloWorldStreamingep = new (9113);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_23,
    descMap: getDescriptorMap23()
}
service "helloWorldServerStreaming" on helloWorldStreamingep {

    isolated remote function lotsOfReplies(HelloWorldServerStreamingHelloResponseCaller caller, HelloRequest value) {
        log:printInfo("Server received hello from " + value.name);
        string[] greets = ["Hi", "Hey", "GM"];

        foreach string greet in greets {
            string message = greet + " " + value.name;
            HelloResponse msg = {message: message};
            Error? err = caller->sendHelloResponse(msg);
            if (err is Error) {
                log:printError("Error from Connector: " + err.message());
            } else {
                log:printInfo("Send reply: " + msg.toString());
            }
        }

        Error? result = caller->complete();
        if (result is Error) {
            log:printError("Error in sending completed notification to caller",
                'error = result);
        }
    }
}

public client class HelloWorldServerStreamingHelloResponseCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendHelloResponse(HelloResponse response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextHelloResponse(ContextHelloResponse response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}


public type ContextHelloResponseStream record {|
    stream<HelloResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextHelloResponse record {|
    HelloResponse content;
    map<string|string[]> headers;
|};


public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};
public type HelloResponse record {|
    string message = "";

|};

public type HelloRequest record {|
    string name = "";

|};

const string ROOT_DESCRIPTOR_23 = "0A2D32335F7365727665725F73747265616D696E675F776974685F7265636F72645F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765324D0A1968656C6C6F576F726C6453657276657253747265616D696E6712300A0D6C6F74734F665265706C696573120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E73653001620670726F746F33";
isolated function getDescriptorMap23() returns map<string> {
    return {
        "23_server_streaming_with_record_service.proto":"0A2D32335F7365727665725F73747265616D696E675F776974685F7265636F72645F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765324D0A1968656C6C6F576F726C6453657276657253747265616D696E6712300A0D6C6F74734F665265706C696573120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E73653001620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C7565427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
