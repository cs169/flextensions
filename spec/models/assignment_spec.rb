# == Schema Information
#
# Table name: assignments
#
#  id                     :bigint           not null, primary key
#  due_date               :datetime
#  enabled                :boolean          default(FALSE)
#  late_due_date          :datetime
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  course_to_lms_id       :bigint           not null
#  external_assignment_id :string
#
# Foreign Keys
#
#  fk_rails_...  (course_to_lms_id => course_to_lmss.id)
#
require 'rails_helper'

RSpec.describe Assignment, type: :model do
  it 'has a valid factory' do
    expect(build(:assignment)).to be_valid
  end

  describe 'custom validations' do
    context 'enabled_requires_date_present' do
      it 'is valid when enabled is false and due_date is blank' do
        assignment = build(:assignment, enabled: false, due_date: nil)
        expect(assignment).to be_valid
      end

      it 'is valid when enabled is true and due_date is present' do
        assignment = build(:assignment, enabled: true, due_date: 2.days.from_now)
        expect(assignment).to be_valid
      end

      it 'is invalid when enabled is true and due_date is blank' do
        assignment = build(:assignment, enabled: true, due_date: nil)
        expect(assignment).not_to be_valid
        expect(assignment.errors[:due_date]).to include('must be present if assignment is enabled')
      end
    end
  end
end
