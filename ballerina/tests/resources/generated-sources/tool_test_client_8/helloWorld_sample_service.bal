import ballerina/grpc;
import ballerina/time;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_HELLOWORLDTIMESTAMP, descMap: getDescriptorMapHelloWorldTimestamp()}
service "helloWorld" on ep {

    remote function getTime(stream<string, grpc:Error?> clientStream) returns time:Utc|error {
    }
    remote function sendTime(stream<time:Utc, grpc:Error?> clientStream) returns string|error {
    }
    remote function exchangeTime(stream<time:Utc, grpc:Error?> clientStream) returns time:Utc|error {
    }
    remote function getGreeting(stream<string, grpc:Error?> clientStream) returns Greeting|error {
    }
    remote function sendGreeting(stream<Greeting, grpc:Error?> clientStream) returns string|error {
    }
    remote function exchangeGreeting(stream<Greeting, grpc:Error?> clientStream) returns Greeting|error {
    }
}

