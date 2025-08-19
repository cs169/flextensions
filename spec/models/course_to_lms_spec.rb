# spec/models/course_to_lms_spec.rb
# == Schema Information
#
# Table name: course_to_lmss
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  course_id          :bigint
#  external_course_id :string
#  lms_id             :bigint
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
  let!(:course) { Course.create!(course_name: 'Test Course', canvas_id: '123') }
  let!(:lms) { Lms.create!(id: 1, lms_name: 'Canvas', use_auth_token: true) }
  let!(:course_to_lms) { described_class.create!(course: course, lms: lms, external_course_id: '123') }

  let(:token) { 'fake_token' }

  describe '#fetch_assignments' do
    let(:assignments_response) do
      [
        { 'id' => '1', 'name' => 'Assignment 1' },
        { 'id' => '2', 'name' => 'Assignment 2' }
      ]
    end

    before do
      stub_request(:get, "#{ENV.fetch('CANVAS_URL')}/api/v1/courses/123/assignments")
        .with(
          headers: {
            'Authorization' => "Bearer #{token}",
            'Content-Type' => 'application/json'
          },
          query: { 'include[]' => 'all_dates' }
        )
        .to_return(status: 200, body: assignments_response.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'fetches and returns assignments from the Canvas API' do
      result = course_to_lms.fetch_canvas_assignments(token)
      expect(result).to be_an(Array)
      expect(result.size).to eq(2)
      expect(result.first.name).to eq('Assignment 1')
    end

    context 'when the API call fails' do
      before do
        stub_request(:get, "#{ENV.fetch('CANVAS_URL')}/api/v1/courses/123/assignments")
          .with(
            headers: {
              'Authorization' => "Bearer #{token}",
              'Content-Type' => 'application/json'
            },
            query: { 'include[]' => 'all_dates' }
          )
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'returns an empty array and logs the error' do
        expect(Rails.logger).to receive(:error).with(/Failed to fetch assignments/)
        result = course_to_lms.fetch_canvas_assignments(token)
        expect(result).to eq([])
      end
    end
  end
end
