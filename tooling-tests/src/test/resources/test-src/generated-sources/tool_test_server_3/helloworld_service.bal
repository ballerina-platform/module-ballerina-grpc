import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: HELLOWORLDFLOAT_DESC}
service "helloWorld" on ep {

    remote function hello(float value) returns stream<float, error?>|error {
    }
}

