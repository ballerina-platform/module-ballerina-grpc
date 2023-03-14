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
import ballerina/io;

public function main() returns error? {
    RouteGuideClient ep = check new ("https://localhost:8980",
        secureSocket = {
            key: {
                certFile: "./resources/public.crt",
                keyFile: "./resources/private.key"
            },
            cert: "./resources/public.crt"
        }
    );
    // Simple RPC
    Feature feature = check ep->GetFeature({latitude: 406109563, longitude: -742186778});
    io:println(`GetFeature: lat=${feature.location.latitude},  lon=${feature.location.longitude}`);

    // Server streaming
    Rectangle rectangle = {
        lo: {latitude: 400000000, longitude: -750000000},
        hi: {latitude: 420000000, longitude: -730000000}
    };
    io:println(`ListFeatures: lowLat=${rectangle.lo.latitude},  lowLon=${rectangle.lo.longitude}, hiLat=${rectangle.hi.latitude},  hiLon=${rectangle.hi.longitude}`);
    stream<Feature, grpc:Error?> features = check ep->ListFeatures(rectangle);
    check features.forEach(function(Feature f) {
        io:println(`Result: lat=${f.location.latitude}, lon=${f.location.longitude}`);
    });

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
        io:println(`Finished trip with ${routeSummary.point_count} points. Passed ${routeSummary.feature_count} features. "Travelled ${routeSummary.distance} meters. It took ${routeSummary.elapsed_time} seconds.`);
    }

    // Bidirectional streaming
    RouteNote[] routeNotes = [
        {location: {latitude: 406109563, longitude: -742186778}, message: "m1"}, 
        {location: {latitude: 411733222, longitude: -744228360}, message: "m2"}, 
        {location: {latitude: 406109563, longitude: -742186778}, message: "m3"}, 
        {location: {latitude: 411733222, longitude: -744228360}, message: "m4"}, 
        {location: {latitude: 411733222, longitude: -744228360}, message: "m5"}
    ];
    RouteChatStreamingClient routeClient = check ep->RouteChat();

    future<error?> f1 = start readResponse(routeClient);

    foreach RouteNote n in routeNotes {
        check routeClient->sendRouteNote(n);
    }
    check routeClient->complete();

    check wait f1;
}

function readResponse(RouteChatStreamingClient routeClient) returns error? {
     RouteNote? receiveRouteNote = check routeClient->receiveRouteNote();
     while receiveRouteNote != () {
         io:println(`Got message '${receiveRouteNote.message}' at lat=${receiveRouteNote.location.latitude},
                lon=${receiveRouteNote.location.longitude}`);
         receiveRouteNote = check routeClient->receiveRouteNote();
     }
}
