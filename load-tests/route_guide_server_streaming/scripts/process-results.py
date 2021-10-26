import csv
import json
import statistics as stats

output_headers = ["Label", "# Samples", "Average", "Median", "90% Line", "95% Line", "99% Line", "Min", "Max", "Error %", "Throughput", "Received KB/sec", "Std. Dev.", "Date", "Payload", "Users"]

def process_ghz_output():
    csv_data = []
    with open("ghz_output.csv", "r") as rfile:
        csv_reader = csv.reader(rfile)
        for line in csv_reader:
            csv_data.append(line)
    csv_data.pop(0)
    csv_data.pop(0)
    print(calc_stat_values(csv_data))

def calc_stat_values(csv_data):
    durations = []
    for data in csv_data:
        durations.append(float(data[0]))
    average = calc_average(durations)
    median = calc_percentiles(durations, 0.5)
    ninety_line = calc_percentiles(durations, 0.9)
    ninety_five_line = calc_percentiles(durations, 0.95)
    ninety_nine_line = calc_percentiles(durations, 0.99)
    max_duration = max(durations)
    min_duration = min(durations)
    std_deviation = calc_std_deviation(durations)
    return average, median, ninety_line, ninety_five_line, ninety_nine_line, max_duration, min_duration, std_deviation

def calc_average(durations):
    return stats.mean(durations)

def calc_percentiles(durations, place):
    durations.sort()
    return durations[int((len(durations) + 1) * place)]

def calc_std_deviation(durations):
    return stats.stdev(durations)

process_ghz_output()