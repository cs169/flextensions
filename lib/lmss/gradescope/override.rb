module Lmss
  module Gradescope
    class Override < BaseOverride
      attr_reader :id

      def initialize(data)
        @id = parse_id(data['deletePath'])
        @student_id = data.dig('override', 'user_id')
        @override_release_date = data.dig('override', 'settings', 'release_date', 'value')
        @override_due_date = data.dig('override', 'settings', 'due_date', 'value')
        @override_late_due_date = data.dig('override', 'settings', 'hard_due_date', 'value')
      end

      private

      def parse_id(raw_id)
        raw_id[/\/extensions\/(\d+)/, 1].to_i
      end
    end
  end
end
