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

import ballerina/time;
import ballerina/grpc;
import ballerina/io;
import ballerina/protobuf.types.'any;

listener grpc:Listener ep61 = new (9161);

type Teacher Person1|Person2;

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_ANY, descMap: getDescriptorMapAny()}
service "AnyTypeServer" on ep61 {

    remote function unaryCall1('any:Any value) returns 'any:Any|error {
        io:println(value);
        string stringValue = "";
        stringValue = check 'any:unpack(value);
        if stringValue == "string" {
            return 'any:pack("Hello Ballerina");
        } else if stringValue == "timestamp" {
            return 'any:pack(check time:utcFromString("2007-12-03T10:15:30.120Z"));
        } else if stringValue == "duration" {
            time:Seconds d = 234d;
            return 'any:pack(d);
        } else if stringValue == "empty" {
            return 'any:pack(());
        }
        return value;

    }
    remote function unaryCall2('any:Any value) returns 'any:Any|error {
        return 'any:pack(23);
    }
    remote function unaryCall3('any:Any value) returns 'any:ContextAny|error {
        map<string|string[]> headers = {anyHeader: "Any Header Value"};
        return {content: 'any:pack("Ballerina"), headers: headers};
    }
    remote function clientStreamingCall(stream<'any:Any, grpc:Error?> clientStream) returns 'any:Any|error {
        Person1 p1 = {name: "John", code: 23};
        return 'any:pack(p1);
    }
    remote function serverStreamingCall('any:Any value) returns stream<'any:Any, error?>|error {
        'any:Any[] teachers = [
            'any:pack(<Person1>{name: "John", code: 23}),
            'any:pack(<Person1>{name: "Ann", code: 24}),
            'any:pack(<Person2>{name: "Ann", code: 24, add: "additional data"})
        ];
        return teachers.toStream();
    }
    remote function bidirectionalStreamingCall(stream<'any:Any, grpc:Error?> clientStream) returns stream<'any:Any, error?>|error {
        return clientStream;
    }
}


