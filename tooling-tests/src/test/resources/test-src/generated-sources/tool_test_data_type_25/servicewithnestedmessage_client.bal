import ballerina/io;

ServiceWithNestedMessageClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    NestedRequestMessage helloRequest = {message: "ballerina", bye_request: {greet: "ballerina", baz: {age: "ballerina"}}, f_info: {id: "ballerina", latest_version: "ballerina", observability: {observability: "ballerina"}}, bars: [{age: "ballerina"}]};
    NestedResponseMessage helloResponse = check ep->hello(helloRequest);
    io:println(helloResponse);
}

