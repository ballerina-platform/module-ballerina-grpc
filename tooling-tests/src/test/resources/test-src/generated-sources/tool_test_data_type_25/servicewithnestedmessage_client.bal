import ballerina/io;

ServiceWithNestedMessageClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    NestedRequestMessage request = {message: "ballerina", bye_request: {greet: "ballerina", baz: {age: "ballerina"}}, f_info: {id: "ballerina", latest_version: "ballerina", observability: {observability: "ballerina"}}, bars: [{age: "ballerina"}]};
    NestedResponseMessage response = check ep->hello(request);
    io:println(response);
}

