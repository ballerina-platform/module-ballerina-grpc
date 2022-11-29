import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    ReqMessage helloRequest = {reqVal1: "ballerina", reqVal2: 1, reqVal3: ["ballerina"], reqVal4: [{reqConfig1: "ballerina", reqConfig2: [{config1: "ballerina", config2: "ballerina", config3: ["ballerina"]}], reqConfig3: {}, reqConfig4: [{config1: "ballerina", config2: "ballerina"}], reqConfig5: ["ballerina"]}], reqVal5: {configurationEnabled: true, config2: ["ballerina"], config3: ["ballerina"]}};
    ResMessage helloResponse = check ep->hello(helloRequest);
    io:println(helloResponse);

    ReqMessage helloBallerinaRequest = {reqVal1: "ballerina", reqVal2: 1, reqVal3: ["ballerina"], reqVal4: [{reqConfig1: "ballerina", reqConfig2: [{config1: "ballerina", config2: "ballerina", config3: ["ballerina"]}], reqConfig3: {}, reqConfig4: [{config1: "ballerina", config2: "ballerina"}], reqConfig5: ["ballerina"]}], reqVal5: {configurationEnabled: true, config2: ["ballerina"], config3: ["ballerina"]}};
    stream<ResMessage, error?> helloBallerinaResponse = check ep->helloBallerina(helloBallerinaRequest);
    check helloBallerinaResponse.forEach(function(ResMessage value) {
        io:println(value);
    });

    ReqMessage helloWorldRequest = {reqVal1: "ballerina", reqVal2: 1, reqVal3: ["ballerina"], reqVal4: [{reqConfig1: "ballerina", reqConfig2: [{config1: "ballerina", config2: "ballerina", config3: ["ballerina"]}], reqConfig3: {}, reqConfig4: [{config1: "ballerina", config2: "ballerina"}], reqConfig5: ["ballerina"]}], reqVal5: {configurationEnabled: true, config2: ["ballerina"], config3: ["ballerina"]}};
    HelloWorldStreamingClient helloWorldStreamingClient = check ep->helloWorld();
    check helloWorldStreamingClient->sendReqMessage(helloWorldRequest);
    check helloWorldStreamingClient->complete();
    ResMessage? helloWorldResponse = check helloWorldStreamingClient->receiveResMessage();
    io:println(helloWorldResponse);

    ReqMessage helloGrpcRequest = {reqVal1: "ballerina", reqVal2: 1, reqVal3: ["ballerina"], reqVal4: [{reqConfig1: "ballerina", reqConfig2: [{config1: "ballerina", config2: "ballerina", config3: ["ballerina"]}], reqConfig3: {}, reqConfig4: [{config1: "ballerina", config2: "ballerina"}], reqConfig5: ["ballerina"]}], reqVal5: {configurationEnabled: true, config2: ["ballerina"], config3: ["ballerina"]}};
    HelloGrpcStreamingClient helloGrpcStreamingClient = check ep->helloGrpc();
    check helloGrpcStreamingClient->sendReqMessage(helloGrpcRequest);
    check helloGrpcStreamingClient->complete();
    ResMessage? helloGrpcResponse = check helloGrpcStreamingClient->receiveResMessage();
    io:println(helloGrpcResponse);
}

