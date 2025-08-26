# spec/models/course_to_lms_spec.rb
# == Schema Information
#
# Table name: course_to_lmss
#
#  id                     :bigint           not null, primary key
#  recent_assignment_sync :jsonb
#  recent_roster_sync     :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  course_id              :bigint
#  external_course_id     :string
#  lms_id                 :bigint
#
# Indexes
#
#  index_course_to_lmss_on_course_id  (course_id)
#  index_course_to_lmss_on_lms_id     (lms_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (lms_id => lmss.id)
#
require 'rails_helper'

RSpec.describe CourseToLms, type: :model do
  let!(:course) { create(:course, :with_staff, course_name: 'Test Course', canvas_id: '123') }
  let!(:course_to_lms) { course.course_to_lms(1) }
  let(:staff_user) { course.staff_users.first }

  describe '#get_all_canvas_assignments' do
    let(:assignments_response) do
      [
        { 'id' => '1', 'name' => 'Assignment 1' },
        { 'id' => '2', 'name' => 'Assignment 2' }
      ]
    end

    before do
      allow_any_instance_of(CanvasFacade).to receive(:get_all_assignments)
        .with('123')
        .and_return(assignments_response)
    end

    it 'fetches and returns assignments from the Canvas API' do
      result = course_to_lms.get_all_canvas_assignments(staff_user)
      expect(result).to be_an(Array)
      expect(result.size).to eq(2)
      expect(result.first['name']).to eq('Assignment 1')
    end

    context 'when the API call fails' do
      before do
        allow_any_instance_of(CanvasFacade).to receive(:get_all_assignments)
          .with('123')
          .and_raise(StandardError, 'Canvas API Error')
      end

      it 'returns an empty array and logs the error' do
        expect(Rails.logger).to receive(:error).with(/Failed to fetch assignments/)
        result = course_to_lms.get_all_canvas_assignments(staff_user)
        expect(result).to eq([])
      end
    end
  end
end
