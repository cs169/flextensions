require 'rails_helper'
require_relative '../../app/helpers/canvas_validation_helper'

describe 'CanvasValidationHelper', :skip, type: :helper do
  class Helper
    include CanvasValidationHelper
  end
  attr_reader :helper

  before do
    @helper = Helper.new
  end

  describe 'is_valid_course_id' do
    it 'returns true on positive integer input' do
      expect(helper.is_valid_course_id(16)).to be(true)
    end

    it 'returns false on negative integer input' do
      expect(helper.is_valid_course_id(-16)).to be(false)
    end

    it 'returns false on boolean input' do
      expect(helper.is_valid_course_id(0.1)).to be(false)
    end

    it 'returns false on alphabetical input' do
      expect(helper.is_valid_course_id('abc')).to be(false)
    end
  end

  describe 'is_valid_assignment_id' do
    it 'returns true on positive integer input' do
      expect(helper.is_valid_assignment_id(16)).to be(true)
    end

    it 'returns false on negative integer input' do
      expect(helper.is_valid_assignment_id(-16)).to be(false)
    end

    it 'returns false on boolean input' do
      expect(helper.is_valid_assignment_id(0.1)).to be(false)
    end

    it 'returns false on alphabetical input' do
      expect(helper.is_valid_assignment_id('abc')).to be(false)
    end
  end

  describe 'is_valid_student_id' do
    it 'returns true on positive integer input' do
      expect(helper.is_valid_student_id(16)).to be(true)
    end

    it 'returns false on negative integer input' do
      expect(helper.is_valid_student_id(-16)).to be(false)
    end

    it 'returns false on boolean input' do
      expect(helper.is_valid_student_id(0.1)).to be(false)
    end

    it 'returns false on alphabetical input' do
      expect(helper.is_valid_student_id('abc')).to be(false)
    end
  end

  describe 'is_valid_student_ids' do
    it 'returns true on positive integral input' do
      expect(helper.is_valid_student_ids([16, 18])).to be(true)
    end

    it 'returns false on negative integer input' do
      expect(helper.is_valid_student_ids([-16, 16])).to be(false)
    end

    it 'returns false on boolean input' do
      expect(helper.is_valid_student_ids([16, 0.1])).to be(false)
    end

    it 'returns false on alphabetical input' do
      expect(helper.is_valid_student_ids(['abc', 16])).to be(false)
    end
  end

  describe 'is_valid_title' do
    it 'returns true on valid input' do
      expect(helper.is_valid_title('hello world')).to be(true)
    end

    it 'returns false invalid characters' do
      expect(helper.is_valid_title('**')).to be(false)
    end

    it 'returns false on too long input' do
      expect(helper.is_valid_title('A' * 50)).to be(false)
    end
  end

  describe 'is_valid_date' do
    it 'returns true on properly formatted dates' do
      expect(helper.is_valid_date('2002-03-16T12:00:00Z')).to be(true)
    end

    it 'returns false on inproperly formatted dates' do
      expect(helper.is_valid_date('March 16th 2002')).to be(false)
    end

    it 'returns false on strings with too much text' do
      expect(helper.is_valid_date('2002-03-16T12:00:00Z*')).to be(false)
    end
  end
end
