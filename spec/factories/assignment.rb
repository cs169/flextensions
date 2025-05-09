FactoryBot.define do
  sequence :assignment_seq do |n|
    n
  end

  factory :assignment do
    transient do
      seq_num { generate(:assignment_seq) }
    end

    name { "Homework #{seq_num}" }
    association :course_to_lms
    external_assignment_id { "ext-assignment-#{seq_num}" }
    due_date { seq_num.days.from_now }
    late_due_date { (seq_num * 10).days.from_now }
    enabled { false }
  end
end
