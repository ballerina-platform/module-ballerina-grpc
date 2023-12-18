import ballerina/grpc;
import ballerina/test;

grpc:ClientConfiguration config1 = {
   secureSocket: {
       cert: "tests/resources/public.crt"
   }
};

grpc:ClientConfiguration config2 = {
    secureSocket: {
        cert: "tests/resources/public2.crt"
    }
};

@test:Config {enable: true}
function testMultipleConfigurationsInMultiClientScenario() returns error? {
    MultipleClientConfigsService1Client ep1 = check new ("https://localhost:9179", config1);
    MultipleClientConfigsService2Client ep2 = check new ("https://localhost:9279", config2);
    check ep1->call1();
    check ep2->call1();
}
