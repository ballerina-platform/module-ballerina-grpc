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
// This is server implementation for unary blocking/unblocking scenario

import ballerina/io;

// Server endpoint configuration
listener Listener ep8 = new (9098, {
    host:"localhost"
});

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_8,
    descMap: getDescriptorMap8()
}
service "HelloWorld101" on ep8 {
    isolated remote function hello(HelloWorld101StringCaller caller, ContextString request) returns error? {
        io:println("name: " + request.content);
        string message = "Hello " + request.content;
        map<string|string[]> responseHeaders = {};

        if (!request.headers.hasKey("x-id")) {
            Error? err = caller->sendError(error AbortedError("x-id header is missing"));
        } else {
            string headerValue = check getHeader(request.headers, "x-id");
            io:println("Request Header: " +  headerValue);
            responseHeaders["x-id"] = ["1234567890", "2233445677"];
            io:print("Response headers: ");
            io:println(getHeaders(request.headers, "x-id"));
        }
        ContextString responseMessage = {content: message, headers: responseHeaders};
        Error? err = caller->sendContextString(responseMessage);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        } else {
            io:println("Server send response : " + message);
        }
        checkpanic caller->complete();
    }
}

public client class HelloWorld101StringCaller {
    private Caller caller;

    public function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendString(string response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextString(ContextString response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

const string ROOT_DESCRIPTOR_8 = "0A2330385F756E6172795F736572766963655F776974685F686561646572732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32540A0D48656C6C6F576F726C6431303112430A0568656C6C6F121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";
isolated function getDescriptorMap8() returns map<string> {
    return {
        "08_unary_service_with_headers.proto":"0A2330385F756E6172795F736572766963655F776974685F686561646572732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32540A0D48656C6C6F576F726C6431303112430A0568656C6C6F121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C7565427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
