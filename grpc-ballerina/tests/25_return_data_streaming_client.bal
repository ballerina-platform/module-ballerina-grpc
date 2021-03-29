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

// This is client implementation for server streaming scenario
import ballerina/io;
import ballerina/test;

@test:Config {enable:true}
function testReceiveStreamingResponseFromReturn() returns Error? {
    string name = "WSO2";
    // Client endpoint configuration
    HelloWorld25Client helloWorldEp = check new("http://localhost:9115");

    var result = helloWorldEp->lotsOfReplies(name);
    if (result is Error) {
        test:assertFail("Error from Connector: " + result.message());
    } else {
        io:println("Connected successfully");
        string[] expectedResults = ["Hi WSO2", "Hey WSO2", "GM WSO2"];
        int count = 0;
        error? e = result.forEach(function(anydata value) {
            test:assertEquals(value, expectedResults[count]);
            count += 1;
        });
        test:assertEquals(count, 3);
    }
}

public client class HelloWorld25Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_25, getDescriptorMap25());
    }

    isolated remote function lotsOfReplies(string req) returns stream<string, Error?>|Error {

        var payload = check self.grpcClient->executeServerStreaming("grpcservices.HelloWorld25/lotsOfReplies", req);
        [stream<anydata, Error?>, map<string|string[]>][result, _] = payload;
        StringStream outputStream = new StringStream(result);
        return new stream<string, Error?>(outputStream);
    }

    isolated remote function lotsOfRepliesContext(string req) returns ContextStringStream|Error {

        var payload = check self.grpcClient->executeServerStreaming("grpcservices.HelloWorld25/lotsOfReplies", req);
        [stream<anydata, Error?>, map<string|string[]>][result, headers] = payload;
        StringStream outputStream = new StringStream(result);
        return {content: new stream<string, Error?>(outputStream), headers: headers};
    }

}

public class StringStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {| string value; |}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {| string value; |} nextRecord = {value: <string>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}
