module LogStatistics
  module Summary

    class Summary

      REGEXP = /Completed.+in (\d+\.?\d?)ms \(Views: (\d+\.?\d?)ms \| ActiveRecord: (\d+\.?\d?)ms\)/

      class << self
        def is_summary(line)
          !(line =~ REGEXP).nil?
        end
      end
      
      def initialize(line)
        @match = line.match(REGEXP)
      end

      def get_req_time
        @match[1].to_f
      end

      def get_view_time
        @match[2].to_f
      end

      def get_ar_time
        @match[3].to_f
      end

    end

  end
end
