import ballerina/io;

ServiceWithNestedMessageClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    NestedRequestMessage request = {message: "Hello", bye_request: {greet: "Hello", baz: {age: "Hello"}}, f_info: {id: "Hello", latest_version: "Hello", observability: {observability: "Hello"}}, bars: [{age: "Hello"}]};
    NestedResponseMessage response = check ep->hello(request);
    io:println(response);
}

