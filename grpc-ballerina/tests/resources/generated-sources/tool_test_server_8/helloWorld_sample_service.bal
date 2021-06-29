import ballerina/grpc;
import ballerina/time;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR, descMap: getDescriptorMap()}
service "helloWorld" on ep {

    remote function getTime(string value) returns stream<time:Utc, error?>|error {
    }
    remote function sendTime(time:Utc value) returns stream<string, error?>|error {
    }
    remote function exchangeTime(time:Utc value) returns stream<time:Utc, error?>|error {
    }
    remote function getGreeting(string value) returns stream<Greeting, error?>|error {
    }
    remote function sendGreeting(Greeting value) returns stream<string, error?>|error {
    }
    remote function exchangeGreeting(Greeting value) returns stream<Greeting, error?>|error {
    }
}
