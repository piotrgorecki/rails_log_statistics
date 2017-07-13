module LogStatistics
  class Parser
    def initialize(log_path, action_url)
      @log_path = log_path
      @action_url = action_url
      @req_started = false
      @summary_accum = []
    end

    def parse
      @summary_reporter = Summary::SummaryReporter.new
      work_with_file_lines do |line|
        set_req_started if is_starting_request(line)

        if is_belongs_to_request
          if Summary::Summary.is_summary(line)
            @summary_reporter.add Summary::Summary.new(line)
            set_req_ended
          end

          if Summary::Summary304.is_summary(line)
            @summary_reporter.add Summary::Summary304.new(line)
            set_req_ended
          end
        end
      end
    end

    def print_report_csv
      r = @summary_reporter.get_report_data
      puts "samples; req mean;req median;req min;req max; view mean;view median;view min;view max; active record mean;active record median;active record min;active record max;"
      puts "#{r[:count]};#{r[:time][:request][:mean]};#{r[:time][:request][:median]};#{r[:time][:request][:min]};#{r[:time][:request][:max]};#{r[:time][:view][:mean]};#{r[:time][:view][:median]};#{r[:time][:view][:min]};#{r[:time][:view][:max]};#{r[:time][:active_record][:mean]};#{r[:time][:active_record][:median]};#{r[:time][:active_record][:min]};#{r[:time][:active_record][:max]};"
    end


    private

    def work_with_file_lines(&block)
      File.open(@log_path, 'r') do |f|
        f.each_line do |line|
          block.call(line)
        end
      end
    end

    def set_req_started
      @req_started = true
    end

    def set_req_ended
      @req_started = false
    end

    def is_belongs_to_request
      @req_started
    end

    def is_starting_request(line)
      (line =~ /^Started.+#{@action_url}/) == 0
    end

  end
end
