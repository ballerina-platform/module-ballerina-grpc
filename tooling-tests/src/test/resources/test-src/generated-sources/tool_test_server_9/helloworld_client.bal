import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    ReqMessage helloRequest = {value: "ballerina"};
    stream<ResMessage, error?> helloResponse = check ep->hello(helloRequest);
    check helloResponse.forEach(function(ResMessage value) {
        io:println(value);
    });
}

