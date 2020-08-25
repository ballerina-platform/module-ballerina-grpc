const string ERROR_MSG_FORMAT = "Error from Connector: %s";
const string RESP_MSG_FORMAT = "Failed: Invalid Response, expected %s, but received %s";

const string KEYSTORE_PATH = "src/grpc/tests/resources/ballerinaKeystore.p12";
const string TRUSTSTORE_PATH = "src/grpc/tests/resources/ballerinaTruststore.p12";
const string PUBLIC_CRT_PATH = "src/grpc/tests/resources/public.crt";
const string PRIVATE_KEY_PATH = "src/grpc/tests/resources/private.key";

public type Empty record {};

public type Request record {
    string name = "";
    string message = "";
    int age = 0;
};

public type Response record {
    string resp = "";
};

type IntTypedesc typedesc<int>;
type BooleanTypedesc typedesc<boolean>;
type FloatTypedesc typedesc<float>;
type TestIntTypedesc typedesc<TestInt>;
type TestStringTypedesc typedesc<TestString>;
type TestBooleanTypedesc typedesc<TestBoolean>;
type TestFloatTypedesc typedesc<TestFloat>;
type TestStructTypedesc typedesc<TestStruct>;
type ResponseTypedesc typedesc<Response>;
type RequestTypedesc typedesc<Request>;