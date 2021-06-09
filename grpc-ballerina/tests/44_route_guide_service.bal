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

listener Listener ep44 = new (9144);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_44, descMap: getDescriptorMap44()}
service "RouteGuide" on ep44 {

    isolated remote function GetFeature(Point point) returns Feature|error {
        return {location: point, name: "f1"};
    }
    isolated remote function RecordRoute(stream<Point, Error?> clientStream) returns RouteSummary|error {
        return {point_count: 1, feature_count: 1, distance: 1, elapsed_time: 1};
    }
    isolated remote function ListFeatures(Rectangle value) returns stream<Feature, error?>|error {
        Feature[] fs = [
            {location: {latitude: 1, longitude: 2}, name: "l1"}, 
            {location: {latitude: 3, longitude: 4}, name: "l2"}, 
            {location: {latitude: 5, longitude: 6}, name: "l3"}
        ];
        return fs.toStream();
    }
    isolated remote function RouteChat(stream<RouteNote, Error?> clientStream) returns stream<RouteNote, error?>|error {
        return clientStream;
    }
}

