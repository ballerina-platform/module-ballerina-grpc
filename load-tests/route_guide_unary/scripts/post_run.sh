#!/bin/bash -e
# Copyright 2021 WSO2 Inc. (http://wso2.org)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
# Post run script for ballerina performance tests
# ----------------------------------------------------------------------------
set -e

export scriptsDir="/home/bal-admin/module-ballerina-grpc/load-tests/route_guide_unary/scripts"
export resultsDir="/home/bal-admin/module-ballerina-grpc/load-tests/route_guide_unary/results"

echo "----------Downloading Ballerina----------"
wget https://dist.ballerina.io/downloads/swan-lake-beta3/ballerina-swan-lake-beta3.zip

echo "----------Setting Up Ballerina----------"
unzip ballerina-swan-lake-beta3.zip
export BAL_PATH=`pwd`/ballerina-swan-lake-beta3/bin/bal

echo "----------Finalizing results----------"
$BAL_PATH run $scriptsDir/process_csv_output/ -- "gRPC Route Guide Unary" 50 "$scriptsDir/ghz_output.csv" "$resultsDir/summary.csv" "6"
