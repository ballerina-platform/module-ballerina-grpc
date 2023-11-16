import ballerina/grpc;
import ballerina/protobuf;

public const string SIMPLE_RPC_WITH_GO_SERVICE_DESC = "0A2335395F73696D706C655F7270635F776974685F676F5F736572766963652E70726F746F120965636F6D6D65726365226B0A0D50726F6475637444657461696C120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12140A0570726963651804200128025205707269636522210A0950726F64756374494412140A0576616C7565180120012809520576616C756522FF020A0D5265706561746564547970657312200A0B696E74333256616C756573180120032805520B696E74333256616C75657312200A0B696E74363456616C756573180220032803520B696E74363456616C75657312220A0C75696E74333256616C75657318032003280D520C75696E74333256616C75657312220A0C75696E74363456616C756573180420032804520C75696E74363456616C75657312220A0C73696E74333256616C756573180520032811520C73696E74333256616C75657312220A0C73696E74363456616C756573180620032812520C73696E74363456616C75657312240A0D6669786564333256616C756573180720032807520D6669786564333256616C75657312240A0D6669786564363456616C756573180820032806520D6669786564363456616C75657312260A0E736669786564333256616C75657318092003280F520E736669786564333256616C75657312260A0E736669786564363456616C756573180A20032810520E736669786564363456616C75657332D1010A0B50726F64756374496E666F123C0A0A61646450726F6475637412182E65636F6D6D657263652E50726F6475637444657461696C1A142E65636F6D6D657263652E50726F647563744944123C0A0A67657450726F6475637412142E65636F6D6D657263652E50726F6475637449441A182E65636F6D6D657263652E50726F6475637444657461696C12460A106765745265706561746564547970657312182E65636F6D6D657263652E526570656174656454797065731A182E65636F6D6D657263652E52657065617465645479706573620670726F746F33";

public isolated client class ProductInfoClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SIMPLE_RPC_WITH_GO_SERVICE_DESC);
    }

    isolated remote function addProduct(ProductDetail|ContextProductDetail req) returns ProductID|grpc:Error {
        map<string|string[]> headers = {};
        ProductDetail message;
        if req is ContextProductDetail {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/addProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductID>result;
    }

    isolated remote function addProductContext(ProductDetail|ContextProductDetail req) returns ContextProductID|grpc:Error {
        map<string|string[]> headers = {};
        ProductDetail message;
        if req is ContextProductDetail {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/addProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductID>result, headers: respHeaders};
    }

    isolated remote function getProduct(ProductID|ContextProductID req) returns ProductDetail|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/getProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductDetail>result;
    }

    isolated remote function getProductContext(ProductID|ContextProductID req) returns ContextProductDetail|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/getProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductDetail>result, headers: respHeaders};
    }

    isolated remote function getRepeatedTypes(RepeatedTypes|ContextRepeatedTypes req) returns RepeatedTypes|grpc:Error {
        map<string|string[]> headers = {};
        RepeatedTypes message;
        if req is ContextRepeatedTypes {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/getRepeatedTypes", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RepeatedTypes>result;
    }

    isolated remote function getRepeatedTypesContext(RepeatedTypes|ContextRepeatedTypes req) returns ContextRepeatedTypes|grpc:Error {
        map<string|string[]> headers = {};
        RepeatedTypes message;
        if req is ContextRepeatedTypes {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/getRepeatedTypes", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RepeatedTypes>result, headers: respHeaders};
    }
}

public client class ProductInfoProductIDCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductID(ProductID response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductID(ContextProductID response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ProductInfoRepeatedTypesCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendRepeatedTypes(RepeatedTypes response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextRepeatedTypes(ContextRepeatedTypes response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ProductInfoProductDetailCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductDetail(ProductDetail response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductDetail(ContextProductDetail response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextRepeatedTypes record {|
    RepeatedTypes content;
    map<string|string[]> headers;
|};

public type ContextProductDetail record {|
    ProductDetail content;
    map<string|string[]> headers;
|};

public type ContextProductID record {|
    ProductID content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SIMPLE_RPC_WITH_GO_SERVICE_DESC}
public type RepeatedTypes record {|
    int[] int32Values = [];
    int[] int64Values = [];
    int:Unsigned32[] uint32Values = [];
    int[] uint64Values = [];
    int:Signed32[] sint32Values = [];
    int[] sint64Values = [];
    int[] fixed32Values = [];
    int[] fixed64Values = [];
    int[] sfixed32Values = [];
    int[] sfixed64Values = [];
|};

@protobuf:Descriptor {value: SIMPLE_RPC_WITH_GO_SERVICE_DESC}
public type ProductDetail record {|
    string id = "";
    string name = "";
    string description = "";
    float price = 0.0;
|};

@protobuf:Descriptor {value: SIMPLE_RPC_WITH_GO_SERVICE_DESC}
public type ProductID record {|
    string value = "";
|};

