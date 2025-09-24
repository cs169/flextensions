module Lmss
  module Gradescope
    class Assignment < Lmss::BaseAssignment
      attr_reader :id, :name, :due_date, :late_due_date

      def initialize(data)
        @id = parse_id(data['id'])
        @name = data['title']
        @due_date = data.dig('submission_window', 'due_date')
        @late_due_date = data.dig('submission_window', 'hard_due_date')
      end

      private

      def parse_id(raw_id)
        raw_id[/\d+/].to_i
      end
    end
  end
end
