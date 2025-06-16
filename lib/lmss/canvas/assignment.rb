module Lmss
  module Canvas
    class Assignment < Lmss::BaseAssignment
      attr_reader :id, :name, :due_date, :late_due_date

      def initialize(data)
        @id = data['id']
        @name = data['name']
        @due_date = extract_date_field(data, 'due_at')
        @late_due_date = extract_date_field(data, 'lock_at')
      end

      private

      def extract_date_field(assignment_data, field_name)
        if assignment_data['base_date'] && assignment_data['base_date'][field_name].present?
          DateTime.parse(assignment_data['base_date'][field_name])
        elsif assignment_data[field_name].present?
          DateTime.parse(assignment_data[field_name])
        end
      end
    end
  end
end
