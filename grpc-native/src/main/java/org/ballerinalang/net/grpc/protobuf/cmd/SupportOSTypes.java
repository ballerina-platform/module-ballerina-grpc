/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.ballerinalang.net.grpc.protobuf.cmd;

/**
 * OS types which is supported by this tool.
 */
class SupportOSTypes {

    private SupportOSTypes() {
    }

    static final String AIX = "aix";
    static final String HPUX = "hpux";
    static final String OS400 = "os400";
    static final String LINUX = "linux";
    static final String MACOSX = "macosx";
    static final String OSX = "osx";
    static final String FREEBSD = "freebsd";
    static final String OPENBSD = "openbsd";
    static final String NETBSD = "netbsd";
    static final String WINDOWS = "windows";
    static final String SOLARIS = "solaris";
    static final String SUNOS = "sunos";
}
