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

const string MESSAGE_DESC = "0A1037335F6D6573736167652E70726F746F120C67727063736572766963657322340A0C5265706C794D657373616765120E0A0269641801200128055202696412140A0576616C7565180220012809520576616C7565620670726F746F33";

@protobuf:Descriptor {value: MESSAGE_DESC}
public type ReplyMessage record {|
    int id = 0;
    string value = "";
|};

