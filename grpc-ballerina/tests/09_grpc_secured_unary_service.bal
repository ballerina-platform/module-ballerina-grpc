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

import ballerina/log;

listener Listener ep9 = new (9099, {
    host:"localhost",
    secureSocket:{
        key: {
            path: KEYSTORE_PATH,
            password: "ballerina"
        },
        mutualSsl: {
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            }
        },
        protocol: {
            name: TLS,
            versions: ["TLSv1.2","TLSv1.1"]
        }
    }
});

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_9,
    descMap: getDescriptorMap9()
}
service "HelloWorld85" on ep9 {
    isolated remote function hello(HelloWorld85StringCaller caller, string name) {
        log:printInfo("name: " + name);
        string message = "Hello " + name;
        Error? err = caller->sendString(message);
        if (err is Error) {
            log:printError(err.message(), 'error = err);
        } else {
            log:printInfo("Server send response : " + message);
        }
        checkpanic caller->complete();
    }
}
