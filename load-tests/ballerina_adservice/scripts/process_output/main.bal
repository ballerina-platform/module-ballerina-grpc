import ballerina/io;
import ballerina/lang.'float as floats;
import ballerina/time;

string ghz_output_path = "./ghz_output.json";

string[] output_headers = ["Label", "# Samples", "Average", "Median", "90% Line", "95% Line", 
                                "99% Line", "Min", "Max", "Error %", "Throughput", "Received KB/sec", 
                                "Std. Dev.", "Date", "Payload", "Users"];

public function main(int users, string csv_path) returns error? {
    json json_data = check io:fileReadJson(ghz_output_path);
    int num_samples = check json_data.options.total;
    int average = check json_data.average;

    json json_distribution = check json_data.latencyDistribution;
    int median = 0;
    int ninety_line = 0;
    int ninety_five_line = 0;
    int ninety_nine_line = 0;

    if json_distribution != () {
        LatencyDistribution[] latency_distributions = check json_distribution.cloneWithType();
        median = latency_distributions[2].latency;
        ninety_line = latency_distributions[4].latency;
        ninety_five_line = latency_distributions[5].latency;
        ninety_nine_line = latency_distributions[6].latency;
    }

    float error_percent = check getErrorPercentage(check json_data.details);

    int minimum = check json_data.fastest;
    int maximum = check json_data.slowest;

    int total_time = check json_data.total;
    io:println(total_time);
    io:println(num_samples);
    float throughput = (<float>num_samples * 1000000.0/<float>total_time);

    float std_deviation = check getStdDeviation(check json_data.details, <float>average);
    int date = time:utcNow()[0];

    var results = [num_samples, average, median, ninety_line, ninety_five_line, ninety_nine_line, 
                        error_percent, throughput, 0, std_deviation, date, 50, 200];

    io:println(results);

    check writeResultsToCsv(results, csv_path);
}

function getErrorPercentage(json details) returns float|error {
    LatencyDetail[] latency_details = check details.cloneWithType();
    int error_count = 0;
    foreach LatencyDetail latency_detail in latency_details {
        if latency_detail.'error != "" {
            error_count += 1;
        }
    }
    return <float>(error_count * 100/latency_details.length());
}

function getStdDeviation(json details, float average) returns float|error {
    LatencyDetail[] latency_details = check details.cloneWithType();
    float sum_deviation = 0f;
    foreach LatencyDetail latency_detail in latency_details {
        sum_deviation += floats:pow(<float>latency_detail.latency - <float>average, 2.0);
    }
    return floats:sqrt(sum_deviation/<float>latency_details.length());
}

function writeResultsToCsv(any[] results, string csv_path) returns error? {
    string[][] readCsv = check io:fileReadCsv(csv_path);
    string[] final_results = [];
    foreach var result in results {
        final_results.push(result.toString());
    }
    readCsv.push(final_results);
    check io:fileWriteCsv(csv_path, readCsv);
}

type LatencyDistribution record {|
    int percentage;
    int latency;
|};

type LatencyDetail record {|
    string timestamp;
    int latency;
    string 'error;
    string status;
|};
