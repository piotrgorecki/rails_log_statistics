module LogStatistics
  module Summary

    class SummaryReporter

      def initialize()
        @summaries = []
        @req_time_list = DescriptiveStatistics::Stats.new([])
        @view_time_list = DescriptiveStatistics::Stats.new([])
        @ar_time_list = DescriptiveStatistics::Stats.new([])
      end

      def add(summary)
        @summaries.push summary
        @req_time_list.push summary.get_req_time
        @view_time_list.push summary.get_view_time
        @ar_time_list.push summary.get_ar_time
      end

      def get_report_data
        {
          count: @summaries.size,
          time: {
            request: calc_statistics(@req_time_list),
            view: calc_statistics(@view_time_list),
            active_record: calc_statistics(@ar_time_list)
          }
        }
      end

      private

      def calc_statistics(list)
        {
          mean: list.mean,
          median: list.median,
          min: list.min,
          max: list.max
        }
      end

    end

  end
end
