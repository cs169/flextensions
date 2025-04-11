require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  before do
    session[:user_id] = user.canvas_uid
  end
  describe 'GET #index' do
    it 'returns success and assigns courses' do
      get :index

      expect(response).to be_successful
      expect(assigns(:teacher_courses)).to_not be_nil
      expect(assigns(:student_courses)).to_not be_nil
    end
  end
  
  #Test that when an instructor import a course, all other staffs and students
  # get their user object created, and they have a course object created as well.

end
