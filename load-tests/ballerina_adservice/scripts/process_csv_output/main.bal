import ballerina/io;
import ballerina/lang.'float as floats;
import ballerina/lang.'array as array;
// import ballerina/time;

string ghz_output_path = "../ghz_output.csv";

string[] output_headers = ["Label", "# Samples", "Average", "Median", "90% Line", "95% Line", 
                                "99% Line", "Min", "Max", "Error %", "Throughput", "Received KB/sec", 
                                "Std. Dev.", "Date", "Payload", "Users"];

public function main(string label, int users, string csv_path) returns error? {
    string[][] csv_data = check io:fileReadCsv(ghz_output_path);
    _ = array:remove(csv_data, 0);
    _ = array:remove(csv_data, 0);
    int num_samples = csv_data.length();
    io:println(num_samples);
    io:println(calc_stat_values(csv_data));
}

function calc_stat_values(string[][] request_data) returns float[]|error {
    float[] durations = [];
    foreach string[] data in request_data {
        durations.push(check floats:fromString(data[0]));
    }

    float[] sorted_durations = array:sort(durations);
    float average = calc_average(durations);
    float median = calc_percentiles(sorted_durations, 0.5);
    float ninety_line = calc_percentiles(sorted_durations, 0.9);
    float ninety_five_line = calc_percentiles(sorted_durations, 0.95);
    float ninety_nine_line = calc_percentiles(sorted_durations, 0.99);
    float max_duration = sorted_durations[sorted_durations.length() - 1];
    float min_duration = sorted_durations[0];
    float std_deviation = calc_std_deviation(sorted_durations, average);
    return [average, median, ninety_line, ninety_five_line, ninety_nine_line, max_duration, min_duration, std_deviation];
}

function calc_average(float[] durations) returns float {
    float sum = 0f;
    foreach float duration in durations {
        sum += duration;
    }
    return sum/<float> durations.length();
}

function calc_percentiles(float[] durations, float place) returns float {
    return durations[<int>(<float>(durations.length() + 1) * place)];
}

function calc_std_deviation(float[] durations, float average) returns float {
    float sum_deviation = 0f;
    foreach float duration in durations {
        sum_deviation += floats:pow((duration - average), 2.0);
    }
    return floats:sqrt(sum_deviation/<float> durations.length());
}

function writeResultsToCsv(any[] results, string summary_path) returns error? {
    string[][] summary_data = check io:fileReadCsv(summary_path);
    string[] final_results = [];
    foreach var result in results {
        final_results.push(result.toString());
    }
    summary_data.push(final_results);
    check io:fileWriteCsv(csv_path, readCsv);
}
