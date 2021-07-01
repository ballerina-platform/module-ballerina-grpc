// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/io;
import ballerina/grpc;

@test:Config{}
function serverTest() returns error? {
    RouteGuideClient ep = check new ("http://localhost:8980");
    // Simple RPC
    Feature feature = check ep->GetFeature({latitude: 406109563, longitude: -742186778});
    Feature expectedFeature = {name:"4001 Tremley Point Road, Linden, NJ 07036, USA", location:{latitude:406109563, longitude:-742186778}};
    test:assertEquals(feature, expectedFeature);

    // Server streaming
    Rectangle rectangle = {
        lo: {latitude: 400000000, longitude: -750000000},
        hi: {latitude: 420000000, longitude: -730000000}
    };
    io:println(`ListFeatures: lowLat=${rectangle.lo.latitude},  lowLon=${rectangle.lo.latitude}, hiLat=${rectangle.hi.latitude},  hiLon=${rectangle.hi.latitude}`);
    stream<Feature, grpc:Error?> features = check ep->ListFeatures(rectangle);
    int serverStreamingCount = 0;
    error? e = features.forEach(function(Feature f) {
        serverStreamingCount += 1;
    });
    test:assertEquals(serverStreamingCount, 100);

    // Client streaming
    Point[] points = [
        {latitude: 406109563, longitude: -742186778}, 
        {latitude: 411733222, longitude: -744228360}, 
        {latitude: 744228334, longitude: -742186778}
    ];
    RecordRouteStreamingClient recordRouteStrmClient = check ep->RecordRoute();
    foreach Point p in points {
        check recordRouteStrmClient->sendPoint(p);
    }
    check recordRouteStrmClient->complete();
    RouteSummary? routeSummary = check recordRouteStrmClient->receiveRouteSummary();
    if routeSummary is RouteSummary {
        test:assertEquals(routeSummary.point_count, 3);
        test:assertEquals(routeSummary.feature_count, 2);
        test:assertEquals(routeSummary.distance, 3697192);
    }

    // Bidirectional streaming
    RouteNote[] routeNotes = [
        {location: {latitude: 406109563, longitude: -742186778}, message: "m1"}, 
        {location: {latitude: 411733222, longitude: -744228360}, message: "m2"}, 
        {location: {latitude: 406109563, longitude: -742186778}, message: "m3"}
    ];
    RouteChatStreamingClient routeClient = check ep->RouteChat();
    foreach RouteNote n in routeNotes {
        check routeClient->sendRouteNote(n);
    }
    check routeClient->complete();
    RouteNote? receiveRouteNote = check routeClient->receiveRouteNote();
    int bidiCount = 0;
    while receiveRouteNote != () {
        bidiCount += 1;
        receiveRouteNote = check routeClient->receiveRouteNote();
    }
    test:assertEquals(bidiCount, 4);
}
