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

import ballerina/random;

class AdUtils {

    map<Ad[]> ads = {};
    private int MAX_ADS_TO_SERVE = 2;

    function init() {
        self.ads = self.getAds();
    }

    function getAds() returns map<Ad[]> {
        Ad camera = {
            redirect_url: "/product/2ZYFJ3GM2N",
            text: "Film camera for sale. 50% off."
        };
        Ad lens = {
            redirect_url: "/product/66VCHSJNUP",
            text: "Vintage camera lens for sale. 20% off."
        };
        Ad recordPlayer = {
            redirect_url: "/product/0PUK6V6EV0",
            text: "Vintage record player for sale. 30% off."
        };
        Ad bike = {
            redirect_url: "/product/9SIQT8TOJO",
            text: "City Bike for sale. 10% off."
        };
        Ad baristaKit = {
            redirect_url: "/product/1YMWWN1N4O",
            text: "Home Barista kitchen kit for sale. Buy one, get second kit for free"
        };
        Ad airPlant = {
            redirect_url: "/product/6E92ZMYYFZ",
            text: "Air plants for sale. Buy two, get third one for free"
        };
        Ad terrarium = {
            redirect_url: "/product/L9ECAV7KIM",
            text: "Terrarium for sale. Buy one, get second one for free"
        };
        return {
            "photography": [camera, lens],
            "vintage": [camera, lens, recordPlayer],
            "cycling": [bike],
            "cookware": [baristaKit],
            "gardening": [airPlant, terrarium]
        };
    }

    public function getRandomAds() returns Ad[]|random:Error {
        Ad[] allAds = [];
        self.ads.forEach(function (Ad[] ads) {
            ads.forEach(function (Ad ad) {
                allAds.push(ad);
            });
        });
        Ad[] randomAds = [];
        foreach int i in 0 ..< self.MAX_ADS_TO_SERVE {
            randomAds.push(allAds[check random:createIntInRange(0, allAds.length())]);
        }
        return randomAds;
    }

    public function getAdsByCategory(string category) returns Ad[] {
        return self.ads.get(category);
    }
}
