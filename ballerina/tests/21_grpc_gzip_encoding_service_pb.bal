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
// This is server implementation for bidirectional streaming scenario

public isolated client class OrderManagementClient {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_21, getDescriptorMap21());
    }

    isolated remote function addOrder(Order|ContextOrder req) returns (string|Error) {
        map<string|string[]> headers = {};
        Order message;
        if (req is ContextOrder) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/addOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function addOrderContext(Order|ContextOrder req) returns (ContextString|Error) {
        map<string|string[]> headers = {};
        Order message;
        if (req is ContextOrder) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/addOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function getOrder(string|ContextString req) returns (Order|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/getOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Order>result;
    }

    isolated remote function getOrderContext(string|ContextString req) returns (ContextOrder|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/getOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Order>result, headers: respHeaders};
    }
}

public client class OrderManagementOrderCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendOrder(Order response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextOrder(ContextOrder response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class OrderManagementStringCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
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

public type ContextOrder record {|
    Order content;
    map<string|string[]> headers;
|};

//public type ContextString record {|
//    string content;
//    map<string|string[]> headers;
//|};

public type Order record {|
    string id = "";
    string[] items = [];
    string description = "";
    float price = 0.0;
    string destination = "";
|};

public type CombinedShipment record {|
    string id = "";
    string status = "";
    Order[] ordersList = [];
|};

const string ROOT_DESCRIPTOR_21 = "0A2332315F677270635F677A69705F656E636F64696E675F736572766963652E70726F746F120965636F6D6D657263651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F2287010A054F72646572120E0A0269641801200128095202696412140A056974656D7318022003280952056974656D7312200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12140A0570726963651804200128025205707269636512200A0B64657374696E6174696F6E180520012809520B64657374696E6174696F6E226C0A10436F6D62696E6564536869706D656E74120E0A0269641801200128095202696412160A06737461747573180220012809520673746174757312300A0A6F72646572734C69737418032003280B32102E65636F6D6D657263652E4F72646572520A6F72646572734C6973743289010A0F4F726465724D616E6167656D656E74123A0A086164644F7264657212102E65636F6D6D657263652E4F726465721A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565123A0A086765744F72646572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A102E65636F6D6D657263652E4F72646572620670726F746F33";

isolated function getDescriptorMap21() returns map<string> {
    return {"21_grpc_gzip_encoding_service.proto": "0A2332315F677270635F677A69705F656E636F64696E675F736572766963652E70726F746F120965636F6D6D657263651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F2287010A054F72646572120E0A0269641801200128095202696412140A056974656D7318022003280952056974656D7312200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12140A0570726963651804200128025205707269636512200A0B64657374696E6174696F6E180520012809520B64657374696E6174696F6E226C0A10436F6D62696E6564536869706D656E74120E0A0269641801200128095202696412160A06737461747573180220012809520673746174757312300A0A6F72646572734C69737418032003280B32102E65636F6D6D657263652E4F72646572520A6F72646572734C6973743289010A0F4F726465724D616E6167656D656E74123A0A086164644F7264657212102E65636F6D6D657263652E4F726465721A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565123A0A086765744F72646572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A102E65636F6D6D657263652E4F72646572620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

