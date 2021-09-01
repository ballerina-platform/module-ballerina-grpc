// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

const string ERROR_MSG_FORMAT = "Error from Connector: %s";
const string RESP_MSG_FORMAT = "Failed: Invalid Response, expected %s, but received %s";

const string KEYSTORE_PATH = "tests/resources/ballerinaKeystore.p12";
const string TRUSTSTORE_PATH = "tests/resources/ballerinaTruststore.p12";
const string PUBLIC_CRT_PATH = "tests/resources/public.crt";
const string PRIVATE_KEY_PATH = "tests/resources/private.key";

const string PROTO_FILE_DIRECTORY = "tests/resources/proto-files/";
const string BAL_FILE_DIRECTORY = "tests/resources/generated-sources/";
const string GENERATED_SOURCES_DIRECTORY = "build/generated-sources/";

type IntTypedesc typedesc<int>;
type BooleanTypedesc typedesc<boolean>;
type FloatTypedesc typedesc<float>;
//type TestIntTypedesc typedesc<TestInt>;
//type TestStringTypedesc typedesc<TestString>;
//type TestBooleanTypedesc typedesc<TestBoolean>;
//type TestFloatTypedesc typedesc<TestFloat>;
//type TestStructTypedesc typedesc<TestStruct>;
//type ResponseTypedesc typedesc<Response>;
//type RequestTypedesc typedesc<Request>;
