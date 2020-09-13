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
import ballerina/log;
import ballerina/test;

// Client endpoint configuration
HelloWorld20BlockingClient helloWorld20BlockingEp = new ("http://localhost:9110");

// Server endpoint configuration
listener Listener ep20 = new (9110, {
    host:"localhost"
});

@test:BeforeSuite
function beforeFunc() {
    log:printInfo("Starting beforeFunc to attach anonymous service");
    error? attach = ep20.__attach(helloService);
    if (attach is error) {
        log:printInfo("Error while attaching the service: " + attach.message());
    }
    error? 'start = ep20.__start();
    if ('start is error) {
        log:printInfo("Error while starting the listener: " + 'start.message());
    }
    log:printInfo("beforeFunc ends execution");
}

@test:Config {
    enable: false
}
function testAnonymousServiceWithBlockingClient() {
    // Executing unary blocking call
    [string, Headers]|Error unionResp = helloWorld20BlockingEp->hello("WSO2");
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        string result = "";
        [result, _] = unionResp;
        test:assertEquals(result, "Hello WSO2");
    }
}

@test:AfterSuite {}
function afterFunc() {
    error? 'stop = ep20.__immediateStop();
    if ('stop is error) {
        log:printInfo("Error while stopping the listener: " + 'stop.message());
    }
    log:printInfo("afterFunc ends execution");
}

// Blocking endpoint.
public client class HelloWorld20BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_20, getDescriptorMap20());
    }

    public remote function hello(string req, Headers? headers = ()) returns ([string, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld101/hello", req, headers);
        anydata result = ();
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        return [result.toString(), resHeaders];
    }
}

//Non-blocking endpoint
public client class HelloWorld20Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_20, getDescriptorMap20());
    }

    public remote function hello(string req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld101/hello", req, msgListener, headers);
    }
}

service helloService =
    @ServiceDescriptor {
        descriptor: ROOT_DESCRIPTOR_20,
        descMap: getDescriptorMap20()
    }
    @ServiceConfig {
        name: "HelloWorld101"
    }
    service {
        resource function hello(Caller caller, string name) {
            log:printInfo("name: " + name);
            string message = "Hello " + name;
            Error? err = caller->send(message);
            if (err is Error) {
                log:printInfo("Error when sending the response: " + err.message());
            } else {
                log:printInfo("Server send response : " + message);
            }
            checkpanic caller->complete();
        }
    };

const string ROOT_DESCRIPTOR_20 = "0A1348656C6C6F576F726C643130312E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32540A0D48656C6C6F576F726C6431303112430A0568656C6C6F121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";
function getDescriptorMap20() returns map<string> {
    return {
        "HelloWorld101.proto":
        "0A1348656C6C6F576F726C643130312E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32540A0D48656C6C6F576F726C6431303112430A0568656C6C6F121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33"
        ,

        "google/protobuf/wrappers.proto":
        "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F627566221C0A0B446F75626C6556616C7565120D0A0576616C7565180120012801221B0A0A466C6F617456616C7565120D0A0576616C7565180120012802221B0A0A496E74363456616C7565120D0A0576616C7565180120012803221C0A0B55496E74363456616C7565120D0A0576616C7565180120012804221B0A0A496E74333256616C7565120D0A0576616C7565180120012805221C0A0B55496E74333256616C7565120D0A0576616C756518012001280D221A0A09426F6F6C56616C7565120D0A0576616C7565180120012808221C0A0B537472696E6756616C7565120D0A0576616C7565180120012809221B0A0A427974657356616C7565120D0A0576616C756518012001280C427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
