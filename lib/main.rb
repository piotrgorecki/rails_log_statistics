# usage:
# ./ ./log/test.log  "/todo/archives/initial_data"

require 'descriptive-statistics'
require 'awesome_print'

require './log_statistics/parser'
require './log_statistics/summary/summary'
require './log_statistics/summary/summary_reporter'

log_path = ARGV[0]
request = ARGV[1]

parser = LogStatistics::Parser.new(log_path, request)
parser.parse
parser.print_report_csv
