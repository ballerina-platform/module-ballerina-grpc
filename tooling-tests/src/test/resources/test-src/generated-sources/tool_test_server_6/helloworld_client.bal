import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest helloRequest = {name: "ballerina"};
    stream<HelloResponse, error?> helloResponse = check ep->hello(helloRequest);
    check helloResponse.forEach(function(HelloResponse value) {
        io:println(value);
    });

    ByeRequest byeRequest = {greet: "ballerina"};
    stream<ByeResponse, error?> byeResponse = check ep->bye(byeRequest);
    check byeResponse.forEach(function(ByeResponse value) {
        io:println(value);
    });
}

