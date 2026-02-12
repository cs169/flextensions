# spec/services/assignment_date_calculator_spec.rb
require 'rails_helper'

RSpec.describe AssignmentDateCalculator, type: :service do
  let(:user) { create(:user, email: 'student@example.com', name: 'Student') }
  let(:course) { create(:course, :with_students, :with_staff, course_name: 'Test Course', canvas_id: '789') }

  let(:original_due_date) { Time.zone.parse('2025-01-15 23:59:00') }
  let(:original_late_due_date) { Time.zone.parse('2025-01-17 23:59:00') }
  let(:requested_due_date) { Time.zone.parse('2025-01-18 23:59:00') }

  let(:assignment_with_late_due_date) do
    Assignment.create!(
      name: 'Assignment with Late Due Date',
      course_to_lms_id: course.course_to_lms(1).id,
      external_assignment_id: 'ext1',
      enabled: true,
      due_date: original_due_date,
      late_due_date: original_late_due_date
    )
  end

  let(:assignment_without_late_due_date) do
    Assignment.create!(
      name: 'Assignment without Late Due Date',
      course_to_lms_id: course.course_to_lms(1).id,
      external_assignment_id: 'ext2',
      enabled: true,
      due_date: original_due_date,
      late_due_date: nil
    )
  end

  let(:request_with_late_due_date) do
    Request.create!(
      user: user,
      course: course,
      assignment: assignment_with_late_due_date,
      reason: 'Need more time',
      requested_due_date: requested_due_date
    )
  end

  let(:request_without_late_due_date) do
    Request.create!(
      user: user,
      course: course,
      assignment: assignment_without_late_due_date,
      reason: 'Need more time',
      requested_due_date: requested_due_date
    )
  end

  before do
    UserToCourse.create!(user: user, course: course, role: 'student')
  end

  describe '#calculate' do
    it 'returns a hash with release_date, due_date, and late_due_date' do
      calculator = described_class.new(
        assignment: assignment_with_late_due_date,
        request: request_with_late_due_date,
        course_settings: nil
      )

      result = calculator.calculate

      expect(result).to be_a(Hash)
      expect(result).to have_key(:release_date)
      expect(result).to have_key(:due_date)
      expect(result).to have_key(:late_due_date)
    end
  end

  describe '#release_date' do
    it 'always returns nil' do
      calculator = described_class.new(
        assignment: assignment_with_late_due_date,
        request: request_with_late_due_date,
        course_settings: nil
      )

      expect(calculator.release_date).to be_nil
    end
  end

  describe '#due_date' do
    it 'returns the requested due date from the request' do
      calculator = described_class.new(
        assignment: assignment_with_late_due_date,
        request: request_with_late_due_date,
        course_settings: nil
      )

      expect(calculator.due_date).to eq(requested_due_date)
    end
  end

  describe '#late_due_date' do
    context 'when assignment has no late due date' do
      it 'returns nil regardless of course settings' do
        course_settings = CourseSettings.create!(
          course: course,
          enable_extensions: true,
          extend_late_due_date: true
        )

        calculator = described_class.new(
          assignment: assignment_without_late_due_date,
          request: request_without_late_due_date,
          course_settings: course_settings
        )

        expect(calculator.late_due_date).to be_nil
      end

      it 'returns nil when extend_late_due_date is false' do
        course_settings = CourseSettings.create!(
          course: course,
          enable_extensions: true,
          extend_late_due_date: false
        )

        calculator = described_class.new(
          assignment: assignment_without_late_due_date,
          request: request_without_late_due_date,
          course_settings: course_settings
        )

        expect(calculator.late_due_date).to be_nil
      end
    end

    context 'when assignment has a late due date' do
      context 'when extend_late_due_date setting is true (default)' do
        let(:course_settings) do
          CourseSettings.create!(
            course: course,
            enable_extensions: true,
            extend_late_due_date: true
          )
        end

        it 'shifts the late due date by the same delta as the extension' do
          # Original due date: Jan 15, Late due date: Jan 17 (2 days later)
          # Extension delta: Jan 18 - Jan 15 = 3 days
          # New late due date: Jan 17 + 3 days = Jan 20
          calculator = described_class.new(
            assignment: assignment_with_late_due_date,
            request: request_with_late_due_date,
            course_settings: course_settings
          )

          expected = Time.zone.parse('2025-01-20 23:59:00')
          expect(calculator.late_due_date).to be_within(1.second).of(expected)
        end
      end

      context 'when extend_late_due_date setting is false' do
        let(:course_settings) do
          CourseSettings.create!(
            course: course,
            enable_extensions: true,
            extend_late_due_date: false
          )
        end

        context 'when original late due date is later than extended due date' do
          let(:short_extension_request) do
            Request.create!(
              user: user,
              course: course,
              assignment: assignment_with_late_due_date,
              reason: 'Need a bit more time',
              requested_due_date: Time.zone.parse('2025-01-16 23:59:00')
            )
          end

          it 'returns the original late due date' do
            # Extended due date (Jan 16) is before late due date (Jan 17)
            # So return the original late due date
            calculator = described_class.new(
              assignment: assignment_with_late_due_date,
              request: short_extension_request,
              course_settings: course_settings
            )

            expect(calculator.late_due_date).to eq(original_late_due_date)
          end
        end

        context 'when extended due date is later than original late due date' do
          let(:long_extension_request) do
            Request.create!(
              user: user,
              course: course,
              assignment: assignment_with_late_due_date,
              reason: 'Need much more time',
              requested_due_date: Time.zone.parse('2025-01-20 23:59:00')
            )
          end

          it 'returns the extended due date' do
            # Extended due date (Jan 20) is after late due date (Jan 17)
            # So return the extended due date
            calculator = described_class.new(
              assignment: assignment_with_late_due_date,
              request: long_extension_request,
              course_settings: course_settings
            )

            expect(calculator.late_due_date).to eq(Time.zone.parse('2025-01-20 23:59:00'))
          end
        end
      end

      context 'when extend_late_due_date setting is nil (defaults to true)' do
        it 'defaults to shifting the late due date by the extension delta' do
          # Create settings without explicitly setting extend_late_due_date
          cs = CourseSettings.create!(
            course: course,
            enable_extensions: true
          )
          # Manually set to nil to simulate pre-migration state
          cs.update_column(:extend_late_due_date, nil)

          calculator = described_class.new(
            assignment: assignment_with_late_due_date,
            request: request_with_late_due_date,
            course_settings: cs
          )

          expected = Time.zone.parse('2025-01-20 23:59:00')
          expect(calculator.late_due_date).to be_within(1.second).of(expected)
        end
      end

      context 'when course_settings is nil' do
        it 'defaults to shifting the late due date (extend_late_due_date = true behavior)' do
          calculator = described_class.new(
            assignment: assignment_with_late_due_date,
            request: request_with_late_due_date,
            course_settings: nil
          )

          expected = Time.zone.parse('2025-01-20 23:59:00')
          expect(calculator.late_due_date).to be_within(1.second).of(expected)
        end
      end
    end
  end
end
