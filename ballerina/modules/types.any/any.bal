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

import ballerina/protobuf.types.'any;
import ballerina/grpc;

# Represents a stream of Any data.
public class AnyStream {
    private stream<anydata, grpc:Error?> anydataStream;

    # Initialize the stream.
    #
    # + anydataStream - anydata stream
    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    # Retrieve the next value of the stream.
    #
    # + return - Returns the next value of the stream or else an error
    public isolated function next() returns record {|'any:Any value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is grpc:Error? {
            return streamValue;
        } else {
            return {value: <'any:Any> streamValue.value};
        }
    }

    # Close the stream.
    #
    # + return - Returns an error if failed to close the stream
    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}
