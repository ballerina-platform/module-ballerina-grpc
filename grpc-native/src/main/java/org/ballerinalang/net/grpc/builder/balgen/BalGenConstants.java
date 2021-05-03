/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.ballerinalang.net.grpc.builder.balgen;

import java.io.File;

/**
 * Constants that use in .bal file generation.
 */
public class BalGenConstants {

    private BalGenConstants() {

    }

    public static final String FILE_SEPARATOR = File.separator;

    public static final String DEFAULT_PACKAGE = "temp";

    public static final String STUB_FILE_PREFIX = "_pb.bal";

    public static final String SAMPLE_FILE_PREFIX = "_sample_client.bal";

    public static final String SAMPLE_SERVICE_FILE_PREFIX = "_sample_service.bal";

    public static final String EMPTY_DATA_TYPE = "Empty";

    public static final String PACKAGE_SEPARATOR = ".";

    public static final String GRPC_CLIENT = "client";

    public static final String GRPC_SERVICE = "service";

    public static final String GRPC_PROXY = "proxy";

    public static final String GOOGLE_STANDARD_LIB = "google.protobuf";

    public static final String GOOGLE_API_LIB = "google.api";
}
