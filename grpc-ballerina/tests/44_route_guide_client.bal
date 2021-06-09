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

import ballerina/test;

@test:Config {enable: true}
isolated function testRouteGuideMessagesWithUnary() returns error? {
    RouteGuideClient ep = check new ("http://localhost:9144");
    Point p = {latitude: 406109563, longitude: -742186778};
    Feature f = check ep->GetFeature(p);
    test:assertEquals(f, {location: p, name: "f1"});
}

@test:Config {enable: true}
function testRouteGuideMessagesWithServerStreaming() returns error? {
    RouteGuideClient ep = check new ("http://localhost:9144");
    Feature[] fs = [
        {location: {latitude: 1, longitude: 2}, name: "l1"}, 
        {location: {latitude: 3, longitude: 4}, name: "l2"}, 
        {location: {latitude: 5, longitude: 6}, name: "l3"}
    ];
    Rectangle rectangle = {
        lo: {latitude: 400000000, longitude: -750000000},
        hi: {latitude: 420000000, longitude: -730000000}
    };
    stream<Feature, Error?> features = check ep->ListFeatures(rectangle);
    int i = 0;
    error? e = features.forEach(function(Feature f) {
        test:assertEquals(f, fs[i]);
        i += 1;
    });
    test:assertEquals(i, 3);
}

@test:Config {enable: true}
function testRouteGuideMessagesWithClientStreaming() returns error? {
    RouteGuideClient ep = check new ("http://localhost:9144");
    Point[] points = [
        {latitude: 406109563, longitude: -742186778}, 
        {latitude: 411733222, longitude: -744228360}, 
        {latitude: 744228334, longitude: -742186778}
    ];
    RecordRouteStreamingClient sc = check ep->RecordRoute();
    foreach Point p in points {
        check sc->sendPoint(p);
    }
    check sc->complete();
    RouteSummary? response = check sc->receiveRouteSummary();
    if response is RouteSummary {
        test:assertEquals(response, {point_count: 1, feature_count: 1, distance: 1, elapsed_time: 1});
    } else {
        test:assertFail(msg = "Unexpected empty response");
    }
}

@test:Config {enable: true}
function testRouteGuideMessagesWithBidirectionalStreaming() returns error? {
    RouteGuideClient ep = check new ("http://localhost:9144");
    RouteNote[] routeNotes = [
        {location: {latitude: 406109563, longitude: -742186778}, message: "m1"}, 
        {location: {latitude: 411733222, longitude: -744228360}, message: "m2"}, 
        {location: {latitude: 406109563, longitude: -742186778}, message: "m3"}
    ];
    RouteChatStreamingClient sc = check ep->RouteChat();
    foreach RouteNote routeNote in routeNotes {
        check sc->sendRouteNote(routeNote);
    }
    check sc->complete();
    int i = 0;
    RouteNote? response = check sc->receiveRouteNote();
    if response is RouteNote {
        test:assertEquals(response, routeNotes[i]);
        i += 1;
    }
    while !(response is ()) {
        response = check sc->receiveRouteNote();
        if response is RouteNote {
            test:assertEquals(response, routeNotes[i]);
            i += 1;
        }
    }
    test:assertEquals(i, 3);
}

