// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/protobuf;

byte[] simpleResponseWithAnnotationDescriptor = [10, 37, 115, 105, 109, 112, 108, 101, 95, 114, 101, 115, 112, 111, 110, 115, 101, 95, 119, 105, 116, 104, 95, 97, 110, 110, 111, 116, 97, 116, 105, 111, 110, 46, 112, 114, 111, 116, 111, 34, 66, 10, 28, 83, 105, 109, 112, 108, 101, 82, 101, 115, 112, 111, 110, 115, 101, 87, 105, 116, 104, 65, 110, 110, 111, 116, 97, 116, 105, 111, 110, 18, 18, 10, 4, 110, 97, 109, 101, 24, 1, 32, 1, 40, 9, 82, 4, 110, 97, 109, 101, 18, 14, 10, 2, 105, 100, 24, 2, 32, 1, 40, 5, 82, 2, 105, 100, 98, 6, 112, 114, 111, 116, 111, 51];

@protobuf:Descriptor{ 
    value: simpleResponseWithAnnotationDescriptor
}
public type SimpleResponseWithAnnotation record {|
    string name = "";
    int id = 0;
|};

