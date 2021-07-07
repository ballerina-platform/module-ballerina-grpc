import ballerina/grpc;
import ballerina/time;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR, descMap: getDescriptorMap()}
service "helloWorld" on ep {

    remote function getTime(string value) returns time:Utc|error {
    }
    remote function sendTime(time:Utc value) returns string|error {
    }
    remote function exchangeTime(time:Utc value) returns time:Utc|error {
    }
    remote function getGreeting(string value) returns Greeting|error {
    }
    remote function sendGreeting(Greeting value) returns string|error {
    }
    remote function exchangeGreeting(Greeting value) returns Greeting|error {
    }
}
