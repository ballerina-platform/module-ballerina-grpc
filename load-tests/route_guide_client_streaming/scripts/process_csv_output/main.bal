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
import ballerina/lang.'float as floats;
import ballerina/lang.'array as array;
import ballerina/time;

public function main(string label, int users, string ghz_csv_path, string output_csv_path, string test_duration) returns error? {
    string[][] csv_data = check io:fileReadCsv(ghz_csv_path);
    _ = array:remove(csv_data, 0);
    _ = array:remove(csv_data, 0);
    int num_samples = csv_data.length();
    var stat_results = check calcStatValues(csv_data);

    float throughput = check calcThroughput(csv_data, test_duration);
    float error_percent = calcErrorPercent(csv_data);

    int date = time:utcNow()[0];

    var results = [label, num_samples, stat_results[0], stat_results[1], stat_results[2], stat_results[3], stat_results[4], stat_results[5],
                        stat_results[6], error_percent, throughput, 0, stat_results[7], date, 0, users];

    check writeResultsToCsv(results, output_csv_path);
}

function calcStatValues(string[][] csv_data) returns float[]|error {
    float[] durations = [];
    foreach string[] data in csv_data {
        durations.push(check floats:fromString(data[0]));
    }

    float[] sorted_durations = array:sort(durations);
    float average = calcAverage(durations);
    float median = calcPercentiles(sorted_durations, 0.5);
    float ninety_line = calcPercentiles(sorted_durations, 0.9);
    float ninety_five_line = calcPercentiles(sorted_durations, 0.95);
    float ninety_nine_line = calcPercentiles(sorted_durations, 0.99);
    float max_duration = sorted_durations[sorted_durations.length() - 1];
    float min_duration = sorted_durations[0];
    float std_deviation = calcStdDeviation(sorted_durations, average);
    return [average, median, ninety_line, ninety_five_line, ninety_nine_line, min_duration, max_duration, std_deviation];
}

function calcAverage(float[] durations) returns float {
    float sum = 0f;
    foreach float duration in durations {
        sum += duration;
    }
    return sum/<float> durations.length();
}

function calcPercentiles(float[] durations, float place) returns float {
    return durations[<int>(<float>(durations.length() + 1) * place)];
}

function calcStdDeviation(float[] durations, float average) returns float {
    float sum_deviation = 0f;
    foreach float duration in durations {
        sum_deviation += floats:pow((duration - average), 2.0);
    }
    return floats:sqrt(sum_deviation/<float> durations.length());
}

function calcErrorPercent(string[][] csv_data) returns float {
    float error_count = 0f;
    foreach string[] data in csv_data {
        if data.length() > 2 && data[2] != "" {
            error_count += 1.0;
        }
    }
    return (error_count/<float>csv_data.length()) * 100.0;
}

function calcThroughput(string[][] csv_data, string test_duration) returns float|error {
    return <float> csv_data.length()/check floats:fromString(test_duration);
}

function writeResultsToCsv(any[] results, string output_path) returns error? {
    string[][] summary_data = check io:fileReadCsv(output_path);
    string[] final_results = [];
    foreach var result in results {
        final_results.push(result.toString());
    }
    summary_data.push(final_results);
    check io:fileWriteCsv(output_path, summary_data);
}
