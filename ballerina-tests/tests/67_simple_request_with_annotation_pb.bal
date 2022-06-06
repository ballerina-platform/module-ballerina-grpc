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

const string simpleRequestWithAnnotationDescriptor = "0A2473696D706C655F726571756573745F776974685F616E6E6F746174696F6E2E70726F746F22410A1B53696D706C655265717565737457697468416E6E6F746174696F6E12120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964620670726F746F33";

@protobuf:Descriptor{
    value: simpleRequestWithAnnotationDescriptor
}
public type SimpleRequestWithAnnotation record {|
    string name = "";
    int id = 0;
|};

