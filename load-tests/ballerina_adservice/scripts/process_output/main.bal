import ballerina/io;
import ballerina/lang.'float as floats;
import ballerina/time;

string ghz_output_path = "./ghz_output.json";

string[] output_headers = ["Label", "# Samples", "Average", "Median", "90% Line", "95% Line", 
                                "99% Line", "Min", "Max", "Error %", "Throughput", "Received KB/sec", 
                                "Std. Dev.", "Date", "Payload", "Users"];

public function main(string label, int users, string csv_path) returns error? {
    json json_data = check io:fileReadJson(ghz_output_path);
    int num_samples = check json_data.count;
    float average = (<float> check json_data.average)/1000000.0;

    json json_distribution = check json_data.latencyDistribution;
    float median = 0;
    float ninety_line = 0;
    float ninety_five_line = 0;
    float ninety_nine_line = 0;

    if json_distribution != () {
        LatencyDistribution[] latency_distributions = check json_distribution.cloneWithType();
        median = <float> latency_distributions[2].latency/1000000.0;
        ninety_line = <float> latency_distributions[4].latency/1000000.0;
        ninety_five_line = <float> latency_distributions[5].latency/1000000.0;
        ninety_nine_line = <float> latency_distributions[6].latency/1000000.0;
    }

    float error_percent = check getErrorPercentage(check json_data.details);

    float minimum = (<float> check json_data.fastest)/1000000.0;
    float maximum = (<float> check json_data.slowest)/1000000.0;

    float total_time = (<float> check json_data.total)/1000000.0;
    io:println(total_time);
    io:println(num_samples);
    float throughput = (<float>num_samples/<float>total_time);

    float std_deviation = check getStdDeviation(check json_data.details, <float>average);
    int date = time:utcNow()[0];

    var results = [label, num_samples, average, median, ninety_line, ninety_five_line, ninety_nine_line, minimum,
                        maximum, error_percent, throughput, 0, std_deviation, date, 0, users];

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
    return (<float>error_count * 100.0/<float>latency_details.length());
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
