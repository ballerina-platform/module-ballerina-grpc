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
import ballerina/test;

// Client endpoint configuration
final HelloWorld20Client helloWorld20BlockingEp = check new ("http://localhost:9110");

// Server endpoint configuration
listener Listener ep20 = new (9110, { host:"localhost"});

@test:BeforeSuite
function beforeFunc() {
    log:print("Starting beforeFunc to attach anonymous service");
    error? attach = ep20.attach(helloService, "HelloWorld101");
    if (attach is error) {
        log:print("Error while attaching the service: " + attach.message());
    }
    error? 'start = ep20.'start();
    if ('start is error) {
        log:print("Error while starting the listener: " + 'start.message());
    }
    log:print("beforeFunc ends execution");
}

@test:Config {
    enable: false
}
function testAnonymousServiceWithBlockingClient() {
    // Executing unary blocking call
    [string, map<string|string[]>]|Error unionResp = helloWorld20BlockingEp->hello("WSO2");
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        string result = "";
        [result, _] = unionResp;
        test:assertEquals(result, "Hello WSO2");
    }
}

@test:AfterSuite {}
function afterFunc() {
    error? 'stop = ep20.immediateStop();
    if ('stop is error) {
        log:print("Error while stopping the listener: " + 'stop.message());
    }
    log:print("afterFunc ends execution");
}

// Blocking endpoint.
public client class HelloWorld20Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_20, getDescriptorMap20());
    }

    isolated remote function hello(string req, map<string|string[]> headers = {}) returns ([string, map<string|string[]>]|Error) {
        var unionResp = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld101/hello", req, headers);
        anydata result = ();
        map<string|string[]> resHeaders;
        [result, resHeaders] = unionResp;
        return [result.toString(), resHeaders];
    }
}

service object {} helloService =
    @ServiceDescriptor {
        descriptor: ROOT_DESCRIPTOR_20,
        descMap: getDescriptorMap20()
    }
    service object {
        isolated remote function hello(Caller caller, string name) {
            log:print("name: " + name);
            string message = "Hello " + name;
            Error? err = caller->send(message);
            if (err is Error) {
                log:print("Error when sending the response: " + err.message());
            } else {
                log:print("Server send response : " + message);
            }
            checkpanic caller->complete();
        }
    };

const string ROOT_DESCRIPTOR_20 = "0A2B32305F756E6172795F636C69656E745F666F725F616E6F6E796D6F75735F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32530A0C48656C6C6F5365727669636512430A0568656C6C6F121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";
isolated function getDescriptorMap20() returns map<string> {
    return {
        "20_unary_client_for_anonymous_service.proto":"0A2B32305F756E6172795F636C69656E745F666F725F616E6F6E796D6F75735F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32530A0C48656C6C6F5365727669636512430A0568656C6C6F121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C7565427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
