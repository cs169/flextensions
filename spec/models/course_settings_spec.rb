# == Schema Information
#
# Table name: course_settings
#
#  id                                 :bigint           not null, primary key
#  auto_approve_days                  :integer          default(0)
#  auto_approve_extended_request_days :integer          default(0)
#  email_subject                      :string           default("Extension Request Status: {{status}} - {{course_code}}")
#  email_template                     :text             default("Dear {{student_name}},\n\nYour extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.\n\nExtension Details:\n- Original Due Date: {{original_due_date}}\n- New Due Date: {{new_due_date}}\n- Extension Days: {{extension_days}}\n\nIf you have any questions, please contact the course staff.\n\nBest regards,\n{{course_name}} Staff")
#  enable_emails                      :boolean          default(FALSE)
#  enable_extensions                  :boolean          default(FALSE)
#  enable_gradescope                  :boolean          default(FALSE)
#  enable_slack_webhook_url           :boolean
#  extend_late_due_date               :boolean          default(TRUE), not null
#  gradescope_course_url              :string
#  max_auto_approve                   :integer          default(0)
#  reply_email                        :string
#  slack_webhook_url                  :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  course_id                          :bigint           not null
#
# Indexes
#
#  index_course_settings_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
require 'rails_helper'

RSpec.describe CourseSettings, type: :model do
  let(:course) { create(:course, canvas_id: 'canvas_123', course_name: 'Test Course', course_code: 'TEST101') }
  let(:course_settings) { course.course_settings }

  describe 'associations' do
    it 'belongs to course' do
      expect(course_settings.course).to eq(course)
    end
  end

  describe 'validations' do
    context 'when enable_gradescope is true' do
      it 'validates gradescope_course_url format' do
        course_settings.enable_gradescope = true
        course_settings.gradescope_course_url = 'https://www.gradescope.com/courses/123456'
        expect(course_settings).to be_valid
      end

      it 'rejects invalid gradescope_course_url' do
        course_settings.enable_gradescope = true
        course_settings.gradescope_course_url = 'https://example.com/invalid'
        expect(course_settings).not_to be_valid
        expect(course_settings.errors[:gradescope_course_url]).to include('must be a valid Gradescope course URL like https://gradescope.com/courses/123456')
      end

      it 'accepts gradescope.com without www' do
        course_settings.enable_gradescope = true
        course_settings.gradescope_course_url = 'https://gradescope.com/courses/789012'
        expect(course_settings).to be_valid
      end

      it 'accepts gradescope_course_url with trailing slash' do
        course_settings.enable_gradescope = true
        course_settings.gradescope_course_url = 'https://www.gradescope.com/courses/123456/'
        expect(course_settings).to be_valid
      end

      it 'rejects gradescope_course_url without course ID' do
        course_settings.enable_gradescope = true
        course_settings.gradescope_course_url = 'https://www.gradescope.com/courses/'
        expect(course_settings).not_to be_valid
      end

      it 'rejects gradescope_course_url with non-numeric course ID' do
        course_settings.enable_gradescope = true
        course_settings.gradescope_course_url = 'https://www.gradescope.com/courses/abc'
        expect(course_settings).not_to be_valid
      end
    end

    context 'when enable_gradescope is false' do
      it 'does not validate gradescope_course_url' do
        course_settings.enable_gradescope = false
        course_settings.gradescope_course_url = 'invalid_url'
        expect(course_settings).to be_valid
      end
    end
  end

  describe '#create_or_update_gradescope_link' do
    context 'when enable_gradescope is true' do
      before do
        course_settings.enable_gradescope = true
        course_settings.gradescope_course_url = 'https://www.gradescope.com/courses/123456'
      end

      it 'creates a CourseToLms record for Gradescope' do
        expect do
          course_settings.save!
        end.to change(CourseToLms, :count).by(1)

        course_to_lms = CourseToLms.find_by(course_id: course.id, lms_id: GRADESCOPE_LMS_ID)
        expect(course_to_lms).to be_present
        expect(course_to_lms.external_course_id).to eq('123456')
      end

      it 'updates existing CourseToLms record if it already exists' do
        CourseToLms.create!(course_id: course.id, lms_id: GRADESCOPE_LMS_ID, external_course_id: '999999')

        expect do
          course_settings.save!
        end.not_to change(CourseToLms, :count)

        course_to_lms = CourseToLms.find_by(course_id: course.id, lms_id: GRADESCOPE_LMS_ID)
        expect(course_to_lms.external_course_id).to eq('123456')
      end

      it 'extracts course ID from URL without www' do
        course_settings.gradescope_course_url = 'https://gradescope.com/courses/789012'
        course_settings.save!

        course_to_lms = CourseToLms.find_by(course_id: course.id, lms_id: GRADESCOPE_LMS_ID)
        expect(course_to_lms.external_course_id).to eq('789012')
      end

      it 'extracts course ID from URL with trailing slash' do
        course_settings.gradescope_course_url = 'https://www.gradescope.com/courses/456789/'
        course_settings.save!

        course_to_lms = CourseToLms.find_by(course_id: course.id, lms_id: GRADESCOPE_LMS_ID)
        expect(course_to_lms.external_course_id).to eq('456789')
      end
    end

    context 'when enable_gradescope is false' do
      before do
        course_settings.enable_gradescope = false
      end

      it 'does not create a CourseToLms record' do
        expect do
          course_settings.save!
        end.not_to change(CourseToLms, :count)
      end
    end

    context 'when toggling enable_gradescope from true to false' do
      it 'does not delete existing CourseToLms record' do
        course_settings.enable_gradescope = true
        course_settings.gradescope_course_url = 'https://www.gradescope.com/courses/123456'
        course_settings.save!

        expect(CourseToLms.find_by(course_id: course.id, lms_id: GRADESCOPE_LMS_ID)).to be_present

        course_settings.enable_gradescope = false
        course_settings.save!

        # CourseToLms should still exist (TODO: this might be expected behavior to clean up)
        expect(CourseToLms.find_by(course_id: course.id, lms_id: GRADESCOPE_LMS_ID)).to be_present
      end
    end

    context 'when updating gradescope_course_url while enabled' do
      it 'updates the external_course_id' do
        course_settings.enable_gradescope = true
        course_settings.gradescope_course_url = 'https://www.gradescope.com/courses/123456'
        course_settings.save!

        course_settings.gradescope_course_url = 'https://www.gradescope.com/courses/999999'
        course_settings.save!

        course_to_lms = CourseToLms.find_by(course_id: course.id, lms_id: GRADESCOPE_LMS_ID)
        expect(course_to_lms.external_course_id).to eq('999999')
      end
    end
  end

  describe '#extract_gradescope_course_id' do
    it 'extracts course ID from valid URL' do
      url = 'https://www.gradescope.com/courses/123456'
      expect(course_settings.extract_gradescope_course_id(url)).to eq('123456')
    end

    it 'extracts course ID from URL without www' do
      url = 'https://gradescope.com/courses/789012'
      expect(course_settings.extract_gradescope_course_id(url)).to eq('789012')
    end

    it 'extracts course ID from URL with trailing slash' do
      url = 'https://www.gradescope.com/courses/456789/'
      expect(course_settings.extract_gradescope_course_id(url)).to eq('456789')
    end
  end

  describe 'extend_late_due_date setting' do
    it 'defaults to true for new course settings' do
      new_course = create(:course, canvas_id: 'canvas_new', course_name: 'New Course', course_code: 'NEW101')
      new_settings = described_class.create!(course: new_course)
      expect(new_settings.extend_late_due_date).to be true
    end

    it 'can be set to false' do
      course_settings.extend_late_due_date = false
      course_settings.save!
      expect(course_settings.reload.extend_late_due_date).to be false
    end

    it 'can be toggled from true to false' do
      course_settings.extend_late_due_date = true
      course_settings.save!
      expect(course_settings.extend_late_due_date).to be true

      course_settings.extend_late_due_date = false
      course_settings.save!
      expect(course_settings.reload.extend_late_due_date).to be false
    end

    it 'can be toggled from false to true' do
      course_settings.extend_late_due_date = false
      course_settings.save!
      expect(course_settings.extend_late_due_date).to be false

      course_settings.extend_late_due_date = true
      course_settings.save!
      expect(course_settings.reload.extend_late_due_date).to be true
    end
  end
end
