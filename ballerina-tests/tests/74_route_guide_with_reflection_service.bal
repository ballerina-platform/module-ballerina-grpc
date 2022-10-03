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

import ballerina/grpc;

listener grpc:Listener ep74 = new (9174, {reflectionEnabled: true});

@grpc:Descriptor {value: ROUTE_GUIDE_DESC}
service "RouteGuide" on ep74 {

    isolated remote function GetFeature(Point point) returns Feature|error {
        return {};
    }

    remote function ListFeatures(RouteGuideFeatureCaller caller, Rectangle rectangle) returns error? {
        return caller->sendFeature({});
    }

    remote function RecordRoute(stream<Point, grpc:Error?> clientStream) returns RouteSummary|error {
        return {};
    }

    remote function RouteChat(RouteGuideRouteNoteCaller caller, stream<RouteNote, grpc:Error?> clientNotesStream) returns error? {
        check caller->sendRouteNote({});
    }
}
