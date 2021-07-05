import ballerina/grpc;
import ballerina/time;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR, descMap: getDescriptorMap()}
service "helloWorld" on ep {

    remote function getTime(stream<string, grpc:Error?> clientStream) returns stream<time:Utc, error?>|error {
    }
    remote function sendTime(stream<time:Utc, grpc:Error?> clientStream) returns stream<string, error?>|error {
    }
    remote function exchangeTime(stream<time:Utc, grpc:Error?> clientStream) returns stream<time:Utc, error?>|error {
    }
    remote function getGreeting(stream<string, grpc:Error?> clientStream) returns stream<Greeting, error?>|error {
    }
    remote function sendGreeting(stream<Greeting, grpc:Error?> clientStream) returns stream<string, error?>|error {
    }
    remote function exchangeGreeting(stream<Greeting, grpc:Error?> clientStream) returns stream<Greeting, error?>|error {
    }
}
