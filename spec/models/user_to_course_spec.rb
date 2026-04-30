require 'rails_helper'

RSpec.describe UserToCourse, type: :model do
  describe 'Lead TA role support' do
    it 'treats leadta as a supported staff role' do
      user_to_course = build(:user_to_course, role: 'leadta')

      expect(described_class.staff_roles).to include('leadta')
      expect(described_class.roles).to include('leadta')
      expect(user_to_course).to be_staff
    end

    it 'treats leadta as a course admin role' do
      user_to_course = build(:user_to_course, role: 'leadta')

      expect(user_to_course).to be_course_admin
    end
  end

  describe '.role_from_canvas_enrollment' do
    it 'normalizes Canvas Lead TA custom role enrollments' do
      enrollment = { 'type' => 'ta', 'role' => 'Lead TA' }

      expect(described_class.role_from_canvas_enrollment(enrollment)).to eq('leadta')
    end

    it 'falls back to the Canvas enrollment type for built-in roles' do
      enrollment = { 'type' => 'teacher' }

      expect(described_class.role_from_canvas_enrollment(enrollment)).to eq('teacher')
    end
  end

  describe '#display_role' do
    it 'formats leadta as Lead TA' do
      user_to_course = build(:user_to_course, role: 'leadta')

      expect(user_to_course.display_role).to eq('Lead TA')
    end
  end
end
