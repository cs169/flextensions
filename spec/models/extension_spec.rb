# spec/models/extension_spec.rb
# == Schema Information
#
# Table name: extensions
#
#  id                    :bigint           not null, primary key
#  initial_due_date      :datetime
#  new_due_date          :datetime
#  student_email         :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  assignment_id         :bigint
#  external_extension_id :string
#  last_processed_by_id  :bigint
#
# Indexes
#
#  index_extensions_on_assignment_id         (assignment_id)
#  index_extensions_on_last_processed_by_id  (last_processed_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignment_id => assignments.id)
#  fk_rails_...  (last_processed_by_id => users.id)
#
require 'rails_helper'

RSpec.describe Extension, type: :model do
  let(:course) { Course.create!(course_name: 'Test Course', canvas_id: '101') }
  let(:lms) { Lms.create!(lms_name: 'Canvas', use_auth_token: true) }
  let(:course_to_lms) { CourseToLms.create!(course: course, lms: lms, external_course_id: '101') }
  let(:assignment) { Assignment.create!(name: 'Test Assignment', external_assignment_id: '200', course_to_lms_id: course_to_lms.id) }

  describe 'associations' do
    it 'belongs to assignment' do
      extension = described_class.new(assignment: assignment)
      expect(extension.assignment).to eq(assignment)
    end

    it 'has one user (optional)' do
      user = User.create!(email: 'student@example.com', canvas_uid: '123')
      extension = described_class.create!(assignment: assignment)
      allow(extension).to receive(:user).and_return(user)
      expect(extension.user).to eq(user)
    end
  end

  describe 'attributes and access' do
    it 'can store and retrieve new_due_date and external_extension_id' do
      due_date = 3.days.from_now
      extension = described_class.create!(
        assignment: assignment,
        student_email: 'student@example.com',
        new_due_date: due_date,
        external_extension_id: 'ext123'
      )

      expect(extension.new_due_date.to_i).to eq(due_date.to_i)
      expect(extension.external_extension_id).to eq('ext123')
      expect(extension.student_email).to eq('student@example.com')
    end
  end
end
