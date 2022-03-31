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

import ballerina/grpc;
import ballerina/protobuf.types.'any;
import ballerina/lang.'string;
import ballerina/test;
import ballerina/time;

type NilType ();

@test:Config {enable: true}
public function testProtbufAnyType() returns error? {
    AnyTypeServerClient ep = check new ("http://localhost:9161");

    'any:Any uc1Value1 = check ep->unaryCall1('any:pack("string"));
    'any:Any uc1Value2 = check ep->unaryCall1('any:pack("timestamp"));
    'any:Any uc1Value3 = check ep->unaryCall1('any:pack("duration"));
    'any:Any uc1Value4 = check ep->unaryCall1('any:pack("empty"));
    'any:Any uc1Value5 = check ep->unaryCall1('any:pack("bytes"));

    string unpackedUc1Value1 = check 'any:unpack(uc1Value1, string);
    time:Utc unpackedUc1Value2 = check 'any:unpack(uc1Value2, time:Utc);
    time:Seconds unpackedUc1Value3 = check 'any:unpack(uc1Value3, time:Seconds);
    NilType unpackedNil = check 'any:unpack(uc1Value4, NilType);
    string unpackedStringUc1Value5 = check 'string:fromBytes(check 'any:unpack(uc1Value5));

    test:assertEquals(unpackedUc1Value1, "Hello Ballerina");
    test:assertEquals(unpackedUc1Value2, check time:utcFromString("2007-12-03T10:15:30.120Z"));
    test:assertEquals(unpackedUc1Value3, 234d);
    test:assertEquals(unpackedNil, ());
    test:assertEquals(unpackedStringUc1Value5, "string value");

    'any:Any uc2Value = check ep->unaryCall2('any:pack(true));
    int unpackedUc2Value = check 'any:unpack(uc2Value, int);
    test:assertEquals(unpackedUc2Value, 23);

    'any:ContextAny uc3Value = check ep->unaryCall3Context('any:pack(true));
    string unpackedUc3Value = check 'any:unpack(uc3Value.content, string);
    test:assertEquals(unpackedUc3Value, "Ballerina");
    test:assertEquals(grpc:getHeader(uc3Value.headers, "anyheader"), "Any Header Value");

    'any:Any[] teachers = [
        'any:pack(<Person1>{name: "John", code: 23}),
        'any:pack(<Person1>{name: "Ann", code: 24}),
        'any:pack(<Person2>{name: "Ann", code: 24, add: "additional data"})
    ];

    Teacher[] expectedTeachers = [
        <Person1>{name: "John", code: 23},
        <Person1>{name: "Ann", code: 24},
        <Person2>{name: "Ann", code: 24, add: "additional data"}
    ];

    stream<'any:Any, error?> serverStream = check ep->serverStreamingCall('any:pack(true));
    'any:Any[] returnedTeachers = [];
    check serverStream.forEach(function('any:Any value) {
        returnedTeachers.push(value);
    });

    foreach int k in 0 ... 2 {
        if k == 2 {
            Person2 p2 = check 'any:unpack(returnedTeachers[k], Person2);
            test:assertEquals(p2, expectedTeachers[k]);
        } else {
            Person1 p1 = check 'any:unpack(returnedTeachers[k], Person1);
            test:assertEquals(p1, expectedTeachers[k]);
        }
    }

    ClientStreamingCallStreamingClient csClient = check ep->clientStreamingCall();
    foreach 'any:Any t in teachers {
        check csClient->sendAny(t);
    }
    check csClient->complete();
    'any:Any? clientStreamingValue = check csClient->receiveAny();
    if clientStreamingValue is 'any:Any {
        Person1 p1ForCs = check 'any:unpack(clientStreamingValue, Person1);
        test:assertEquals(p1ForCs, expectedTeachers[0]);
    } else {
        test:assertFail("Expected client streaming return value not found");
    }

    BidirectionalStreamingCallStreamingClient bdClient = check ep->bidirectionalStreamingCall();
    foreach 'any:Any t in teachers {
        check bdClient->sendAny(t);
    }
    check bdClient->complete();
    'any:Any[] returnedTeachersForBidi = [];
    'any:Any? response = check bdClient->receiveAny();
    if response is 'any:Any {
        returnedTeachersForBidi.push(response);
    }
    while !(response is ()) {
        response = check bdClient->receiveAny();
        if response is 'any:Any {
            returnedTeachersForBidi.push(response);
        }
    }
    foreach int k in 0 ... 2 {
        if k == 2 {
            Person2 p2 = check 'any:unpack(returnedTeachersForBidi[k], Person2);
            test:assertEquals(p2, expectedTeachers[k]);
        } else {
            Person1 p1 = check 'any:unpack(returnedTeachersForBidi[k], Person1);
            test:assertEquals(p1, expectedTeachers[k]);
        }
    }
}
