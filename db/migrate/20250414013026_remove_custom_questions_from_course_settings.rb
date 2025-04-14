class RemoveCustomQuestionsFromCourseSettings < ActiveRecord::Migration[7.1]
  def change
    remove_column :course_settings, :custom_question_1, :text
    remove_column :course_settings, :custom_question_2, :text
    remove_column :course_settings, :custom_question_3, :text
  end
end
