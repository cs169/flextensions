# == Schema Information
#
# Table name: courses
#
#  id                 :bigint           not null, primary key
#  course_code        :string
#  course_name        :string
#  readonly_api_token :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  canvas_id          :string
#
# Indexes
#
#  index_courses_on_canvas_id           (canvas_id) UNIQUE
#  index_courses_on_readonly_api_token  (readonly_api_token) UNIQUE
#
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
