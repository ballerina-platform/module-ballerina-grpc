import ballerina/grpc;

listener grpc:Listener multiConfigListener1 = new (9179, secureSocket = {
    key: {
        certFile: "tests/resources/public.crt",
        keyFile: "tests/resources/private.key"
    }
});

@grpc:Descriptor {value: MULTIPLE_CLIENT_CONFIGURATIONS_DESC}
service "MultipleClientConfigsService1" on multiConfigListener1 {

    remote function call1() returns error? {
    }
}

listener grpc:Listener multiConfigListener2 = new (9279, secureSocket = {
    key: {
        certFile: "tests/resources/public2.crt",
        keyFile: "tests/resources/private2.key"
    }
});

@grpc:Descriptor {value: MULTIPLE_CLIENT_CONFIGURATIONS_DESC}
service "MultipleClientConfigsService2" on multiConfigListener2 {

    remote function call1() returns error? {
    }
}
