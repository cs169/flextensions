# == Schema Information
#
# Table name: lmss
#
#  id             :bigint           not null, primary key
#  lms_name       :string
#  lms_base_url   :string
#  use_auth_token :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Lms < ApplicationRecord
  # Relationship with Course (and CourseToLms)
  has_many :course_to_lmss
  has_many :courses, through: :course_to_lmss

  # Relationship with Assignment
  has_many :assignments

  # Singleton instances for each LMS
  def self.CANVAS_LMS
    @canvas_lms ||= find_or_create_by(
      id: 1,
      lms_name: 'Canvas',
      lms_base_url: ENV.fetch('CANVAS_URL', ''),
      use_auth_token: true
    )
  end

  def self.GRADESCOPE_LMS
    @gradescope_lms ||= find_or_create_by(
      id: 2,
      lms_name: 'Gradescope',
      lms_base_url: 'https://www.gradescope.com',
      use_auth_token: false
    )
  end

  # Map a linked LMS to the appropriate API facade which can be used to post extension requests
  # This requires us to map db ids to each facade in app/facades
  # You should be able to call item.course_to_lms.lms_id to get the LMS ID
  def self.facade_class(id)
    case id
    when CANVAS_LMS_ID
      CanvasFacade
    when GRADESCOPE_LMS_ID
      GradescopeFacade
    else
      raise "Unsupported LMS ID: #{id}"
    end
  end
end
