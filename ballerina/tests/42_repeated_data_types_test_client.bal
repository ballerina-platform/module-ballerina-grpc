// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/test;

@test:Config {enable: true}
function testServerStreamingWithDifferentTypes() returns Error? {
    DataTypesServiceClient ep = check new ("http://localhost:9142");
    stream<Int32ArrMsg, Error?> int32Strm = check ep->helloWithInt32Array("int32");
    int c1 = 0;
    Int32ArrMsg[] int32Arr = [
        {note: "note1", arr: [1, 2, 3]},
        {note: "note2", arr: [1, 2, 3, 4]},
        {note: "note3", arr: [1, 2, 3, 4, 5]},
        {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
        {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
    ];
    error? e1 = int32Strm.forEach(function(Int32ArrMsg msg) {
        test:assertEquals(int32Arr[c1], msg);
        c1 += 1;
    });
    test:assertEquals(c1, 5);

    stream<Int64ArrMsg, Error?> int64Strm = check ep->helloWithInt64Array("int64");
    int c2 = 0;
    Int64ArrMsg[] int64Arr = [
        {note: "note1", arr: [1, 2, 3]},
        {note: "note2", arr: [1, 2, 3, 4]},
        {note: "note3", arr: [1, 2, 3, 4, 5]},
        {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
        {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
    ];
    error? e2 = int64Strm.forEach(function(Int64ArrMsg msg) {
        test:assertEquals(int64Arr[c2], msg);
        c2 += 1;
    });
    test:assertEquals(c2, 5);

    stream<UnsignedInt64ArrMsg, Error?> unsignedInt64Strm = check ep->helloWithUnsignedInt64Array("uint64");
    int c3 = 0;
    UnsignedInt64ArrMsg[] unsignedInt64Arr = [
        {note: "note1", arr: [1, 2, 3]},
        {note: "note2", arr: [1, 2, 3, 4]},
        {note: "note3", arr: [1, 2, 3, 4, 5]},
        {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
        {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
    ];
    error? e3 = unsignedInt64Strm.forEach(function(UnsignedInt64ArrMsg msg) {
        test:assertEquals(unsignedInt64Arr[c3], msg);
        c3 += 1;
    });
    test:assertEquals(c3, 5);

    stream<Fixed32ArrMsg, Error?> fixed32Strm = check ep->helloWithFixed32Array("fixed32");
    int c4 = 0;
    Fixed32ArrMsg[] fixed32Arr = [
        {note: "note1", arr: [1, 2, 3]},
        {note: "note2", arr: [1, 2, 3, 4]},
        {note: "note3", arr: [1, 2, 3, 4, 5]},
        {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
        {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
    ];
    error? e4 = fixed32Strm.forEach(function(Fixed32ArrMsg msg) {
        test:assertEquals(fixed32Arr[c4], msg);
        c4 += 1;
    });
    test:assertEquals(c4, 5);

    stream<Fixed64ArrMsg, Error?> fixed64Strm = check ep->helloWithFixed64Array("sint64");
    int c5 = 0;
    Fixed64ArrMsg[] fixed64Arr = [
        {note: "note1", arr: [1, 2, 3]},
        {note: "note2", arr: [1, 2, 3, 4]},
        {note: "note3", arr: [1, 2, 3, 4, 5]},
        {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
        {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
    ];
    error? e5 = fixed64Strm.forEach(function(Fixed64ArrMsg msg) {
        test:assertEquals(fixed64Arr[c5], msg);
        c5 += 1;
    });
    test:assertEquals(c5, 5);

    stream<FloatArrMsg, Error?> floatStrm = check ep->helloWithFloatArray("float");
    int c6 = 0;
    FloatArrMsg[] floatArr = [
        {note: "note1", arr: [1.0, 2.0, 3.0]},
        {note: "note2", arr: [1.0, 2.0, 3.0, 4.0]},
        {note: "note3", arr: [1.0, 2.0, 3.0, 4.0, 5.0]},
        {note: "note4", arr: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]},
        {note: "note5", arr: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]}
    ];
    error? e6 = floatStrm.forEach(function(FloatArrMsg msg) {
        test:assertEquals(floatArr[c6], msg);
        c6 += 1;
    });
    test:assertEquals(c6, 5);

    stream<DoubleArrMsg, Error?> doubleStrm = check ep->helloWithDoubleArray("double");
    int c7 = 0;
    DoubleArrMsg[] doubleArr = [
        {note: "note1", arr: [1.0, 2.0, 3.0]},
        {note: "note2", arr: [1.0, 2.0, 3.0, 4.0]},
        {note: "note3", arr: [1.0, 2.0, 3.0, 4.0, 5.0]},
        {note: "note4", arr: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]},
        {note: "note5", arr: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]}
    ];
    error? e7 = doubleStrm.forEach(function(DoubleArrMsg msg) {
        test:assertEquals(doubleArr[c7], msg);
        c7 += 1;
    });
    test:assertEquals(c7, 5);

    stream<StringArrMsg, Error?> stringStrm = check ep->helloWithStringArray("string");
    int c8 = 0;
    StringArrMsg[] stringArr = [
        {note: "note1", arr: ["A"]},
        {note: "note2", arr: ["A", "B"]},
        {note: "note3", arr: ["A", "B", "C"]},
        {note: "note4", arr: ["A", "B", "C", "D"]},
        {note: "note5", arr: ["A", "B", "C", "D", "E"]}
    ];
    error? e8 = stringStrm.forEach(function(StringArrMsg msg) {
        test:assertEquals(stringArr[c8], msg);
        c8 += 1;
    });
    test:assertEquals(c8, 5);

    stream<BooleanArrMsg, Error?> booleanStrm = check ep->helloWithBooleanArray("boolean");
    int c9 = 0;
    BooleanArrMsg[] booleanArr = [
        {note: "note1", arr: [true]},
        {note: "note2", arr: [true, false]},
        {note: "note3", arr: [true, false, true]},
        {note: "note4", arr: [true, false, true, false]},
        {note: "note5", arr: [true, false, true, false, true]}
    ];
    error? e9 = booleanStrm.forEach(function(BooleanArrMsg msg) {
        test:assertEquals(booleanArr[c9], msg);
        c9 += 1;
    });
    test:assertEquals(c9, 5);

    stream<BytesArrMsg, Error?> bytesStrm = check ep->helloWithBytesArray("bytes");
    int c10 = 0;
    BytesArrMsg[] bytesArr = [
        {note: "note1", arr: "A".toBytes()},
        {note: "note2", arr: "B".toBytes()},
        {note: "note3", arr: "C".toBytes()},
        {note: "note4", arr: "D".toBytes()},
        {note: "note5", arr: "E".toBytes()}
    ];
    error? e10 = bytesStrm.forEach(function(BytesArrMsg msg) {
        test:assertEquals(bytesArr[c10], msg);
        c10 += 1;
    });
    test:assertEquals(c10, 5);
}
