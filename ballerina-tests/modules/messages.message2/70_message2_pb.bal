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

const string MESSAGE2_DESC = "0A1137305F6D657373616765322E70726F746F12097061636B6167696E671A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F22340A0A5265734D65737361676512100A03726571180120012805520372657112140A0576616C7565180220012809520576616C7565421FE2471C677270635F74657374732E6D657373616765732E6D65737361676532620670726F746F33";

@protobuf:Descriptor {value: MESSAGE2_DESC}
public type ResMessage record {|
    int req = 0;
    string value = "";
|};

