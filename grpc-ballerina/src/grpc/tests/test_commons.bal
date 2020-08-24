const string ERROR_MSG_FORMAT = "Error from Connector: %s";
const string KEYSTORE_PATH = "src/grpc/tests/resources/ballerinaKeystore.p12";
const string TRUSTSTORE_PATH = "src/grpc/tests/resources/ballerinaTruststore.p12";

public type Empty record {};

type IntTypedesc typedesc<int>;
type BooleanTypedesc typedesc<boolean>;
type FloatTypedesc typedesc<float>;
type TestIntTypedesc typedesc<TestInt>;
type TestStringTypedesc typedesc<TestString>;
type TestBooleanTypedesc typedesc<TestBoolean>;
type TestFloatTypedesc typedesc<TestFloat>;
type TestStructTypedesc typedesc<TestStruct>;