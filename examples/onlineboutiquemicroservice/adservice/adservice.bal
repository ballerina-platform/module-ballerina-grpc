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

listener grpc:Listener adListener = new (9555);
AdUtils adUtils = new();

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "AdService" on adListener {

    remote function GetAds(AdRequest request) returns AdResponse|error? {
        Ad[] ads = [];
        foreach string category in request.context_keys {
            Ad[] availableAds = adUtils.getAdsByCategory(category);
            availableAds.forEach(function (Ad ad) {
                ads.push(ad);
            });
        }
        if ads.length() == 0 {
            ads = check adUtils.getRandomAds();
        }
        AdResponse response = {
            ads: ads
        };
        return response;
    }

}
