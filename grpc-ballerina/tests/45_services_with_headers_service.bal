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
import ballerina/log;

listener Listener ep45 = new (9145);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_45, descMap: getDescriptorMap45()}
service "HeadersService" on ep45 {

    remote function unary(HeadersServiceHSResCaller caller, ContextHSReq req) returns error? {
        map<string|string[]> responseHeaders = {};
        if (!req.headers.hasKey("unary-req-header")) {
            Error? err = caller->sendError(error AbortedError("unary-req-header header is missing"));
            return;
        } else {
            string headerValue = check getHeader(req.headers, "unary-req-header");
            log:printInfo("Request Header: " + headerValue);
            responseHeaders["unary-res-header"] = ["abcde", "fgh"];
        }
        check caller->sendContextHSRes({content: req.content, headers: responseHeaders});
        check caller->complete();
    }

    remote function serverStr(HeadersServiceHSResCaller caller, ContextHSReq req) returns error? {
        map<string|string[]> responseHeaders = {};
        if (!req.headers.hasKey("server-steaming-req-header")) {
            Error? err = caller->sendError(error AbortedError("server-steaming-req-header header is missing"));
            return;
        } else {
            string headerValue = check getHeader(req.headers, "server-steaming-req-header");
            log:printInfo("Request Header: " + headerValue);
            responseHeaders["server-steaming-res-header"] = ["1234567890", "2233445677"];
        }

        HSRes[] responses = [
            {name: "Ann", message: "Hey"}, 
            {name: "John", message: "Hello"}, 
            {name: "Kathy", message: "Hi"}, 
            {name: "Miller", message: "Bro"}
        ];
        foreach HSRes res in responses {
            check caller->sendContextHSRes({content: res, headers: responseHeaders});
        }
        check caller->complete();
    }

    remote function clientStr(HeadersServiceHSResCaller caller, ContextHSReqStream req) returns error? {
        map<string|string[]> responseHeaders = {};
        if (!req.headers.hasKey("client-steaming-req-header")) {
            Error? err = caller->sendError(error AbortedError("client-steaming-req-header header is missing"));
            return;
        } else {
            string headerValue = check getHeader(req.headers, "client-steaming-req-header");
            log:printInfo("Request Header: " + headerValue);
            responseHeaders["client-steaming-res-header"] = ["1234567890", "2233445677"];
        }
        int i = 0;
        error? e = req.content.forEach(function(HSReq req) {
            HSRes res = {name: req.name, message: req.message};
            if (i == 0) {
                checkpanic caller->sendContextHSRes({content: res, headers: responseHeaders});
                checkpanic caller->complete();
                return;
            }
        });
    }

    remote function bidirectionalStr(HeadersServiceHSResCaller caller, ContextHSReqStream req) returns error? {
        map<string|string[]> responseHeaders = {};
        if (!req.headers.hasKey("bidi-steaming-req-header")) {
            Error? err = caller->sendError(error AbortedError("bidi-steaming-req-header header is missing"));
            return;
        } else {
            string headerValue = check getHeader(req.headers, "bidi-steaming-req-header");
            log:printInfo("Request Header: " + headerValue);
            responseHeaders["bidi-steaming-res-header"] = ["1234567890", "2233445677"];
        }
        int i = 0;
        error? e = req.content.forEach(function(HSReq req) {
            HSRes res = {name: req.name, message: req.message};
            if (i == 0) {
                checkpanic caller->sendContextHSRes({content: res, headers: responseHeaders});
            } else {
                checkpanic caller->sendHSRes(res);
            }
            i += 1;
        });
        log:printInfo("client messages", count = i);
        check caller->complete();
    }
}

