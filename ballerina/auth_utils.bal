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

// Logs and prepares the `error` as an `http:ClientAuthError`.
isolated function prepareClientAuthError(string message, error? err = ()) returns ClientAuthError {
    log:printError(message, 'error = err);
    if err is error {
        return error ClientAuthError(message + " " + err.message(), err);
    }
    return error ClientAuthError(message);
}

// Extract the credential from `map<string|string[]>`
isolated function extractCredential(map<string|string[]> headers) returns string|Error {
    string authHeader = check getHeader(headers, AUTH_HEADER);
    string[] splittedHeader = re`\s`.split(authHeader);
    string[] formattedHeader = from string headerVal in splittedHeader where headerVal != "" select headerVal;
    if formattedHeader.length() > 1 {
        return formattedHeader[1];
    } else {
        return error UnauthenticatedError("Empty authentication header.");
    }
}

// Extract the scheme from `map<string|string[]>`
isolated function extractScheme(map<string|string[]> headers) returns string|Error {
    string authHeader = check getHeader(headers, AUTH_HEADER);
    string[] splittedHeader = re`\s`.split(authHeader);
    return splittedHeader[0];
}

// Match the expectedScopes with actualScopes and return if there is a match.
isolated function matchScopes(string|string[] actualScopes, string|string[] expectedScopes) returns boolean {
    if expectedScopes is string {
        if actualScopes is string {
            return actualScopes == expectedScopes;
        } else {
            foreach string actualScope in actualScopes {
                if actualScope == expectedScopes {
                    return true;
                }
            }
        }
    } else {
        if actualScopes is string {
            foreach string expectedScope in expectedScopes {
                if actualScopes == expectedScope {
                    return true;
                }
            }
        } else {
            foreach string actualScope in actualScopes {
                foreach string expectedScope in expectedScopes {
                    if actualScope == expectedScope {
                        return true;
                    }
                }
            }
        }
    }
    log:printDebug("Failed to match the scopes. Expected '" + expectedScopes.toString() + "', but found '" +
                    actualScopes.toString());
    return false;
}

// Constructs an array of groups from the given space-separated string of groups.
isolated function convertToArray(string spaceSeperatedString) returns string[] {
    if spaceSeperatedString.length() == 0 {
        return [];
    }
    return re`\s`.split(spaceSeperatedString);
}
