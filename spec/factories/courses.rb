FactoryBot.define do
  factory :course do
    sequence(:course_name) { |n| "Course #{n}" }
    sequence(:canvas_id, &:to_s)
    sequence(:course_code) { |n| "COURSE#{n}" }

    after(:create) do |course|
      lms = Lms.find_by(id: 1) || create(:lms, id: 1, lms_name: 'Canvas')

      create(:course_settings, course: course)
      create(:form_setting, course: course)
      course_to_lms = create(:course_to_lms, course: course, lms: lms)
      create_list(:assignment, 5, course_to_lms: course_to_lms)
    end
  end
end
