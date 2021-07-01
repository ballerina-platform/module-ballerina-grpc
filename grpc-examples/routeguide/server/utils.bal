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

import ballerina/io;
import ballerina/lang.'int;
import ballerina/lang.'float;
import ballerina/grpc;

type FeatureArray Feature[];
final readonly & Feature[] FEATURES = check populateFeatures();
configurable string featuresFilePath = "./resources/route_guide_db.json";
RouteNote[] ROUTE_NOTES = [];

function sendRouteNotesFromLocation(RouteGuideRouteNoteCaller caller, Point location) {
    lock {
        foreach RouteNote note in ROUTE_NOTES {
            if note.location == location {
                grpc:Error? e = caller->sendRouteNote(note);
                if e is grpc:Error {
                    grpc:Error? sendErr = caller->sendError(e);
                }
            }
        }
    }
}

function addRouteNotes(stream<RouteNote, grpc:Error?> clientStream) returns error? {
    check clientStream.forEach(function(RouteNote note) {
        lock {
            ROUTE_NOTES.push(note);
        }
    });
}

isolated function toRadians(float f) returns float {
    return f * 'float:PI / 180.0;
}

function calculateDistance(Point p1, Point p2) returns int {
    float cordFactor = 10000000; // 1x(10^7) OR 1e7
    float R = 6371000; // Earth radius in metres
    float lat1 = toRadians(<float>p1.latitude / cordFactor);
    float lat2 = toRadians(<float>p2.latitude / cordFactor);
    float lng1 = toRadians(<float>p1.longitude / cordFactor);
    float lng2 = toRadians(<float>p2.longitude / cordFactor);
    float dlat = lat2 - lat1;
    float dlng = lng2 - lng1;

    float a = 'float:sin(dlat / 2.0) * 'float:sin(dlat / 2.0) + 'float:cos(lat1) * 'float:cos(lat2) * 'float:sin(dlng / 2.0) * 'float:sin(dlng / 2.0);
    float c = 2.0 * 'float:atan2('float:sqrt(a), 'float:sqrt(1.0 - a));
    float distance = R * c;
    return <int>distance;
}

isolated function inRange(Point point, Rectangle rectangle) returns boolean {
    int left = 'int:min(rectangle.lo.longitude, rectangle.hi.longitude);
    int right = 'int:max(rectangle.lo.longitude, rectangle.hi.longitude);
    int top = 'int:max(rectangle.lo.latitude, rectangle.hi.latitude);
    int bottom = 'int:min(rectangle.lo.latitude, rectangle.hi.latitude);

    if point.longitude >= left && point.longitude <= right && point.latitude >= bottom && point.latitude <= top {
        return true;
    }
    return false;
}

isolated function pointExistsInFeatures(Feature[] features, Point point) returns boolean {
    foreach Feature feature in features {
        if feature.location == point {
            return true;
        }
    }
    return false;
}

isolated function featureFromPoint(Point point) returns Feature?|error {
    foreach Feature feature in FEATURES {
        if feature.location == point {
            return feature;
        }
    }
    return ();
}

isolated function populateFeatures() returns readonly & Feature[]|error {
    json locationsJson = check io:fileReadJson(featuresFilePath);
    Feature[] features = check locationsJson.cloneWithType(FeatureArray);
    return features.cloneReadOnly();
}
