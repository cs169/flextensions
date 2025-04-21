require 'rails_helper'

describe ExtensionFacadeBase do
  let(:facade) { described_class.new }
  let(:mockCourseId) { 16 }
  let(:mockStudentId) { 22 }
  let(:mockAssignmentId) { 18 }
  let(:mockDate) { '2002-03-16:16:00:00Z' }

  describe 'provision_extension' do
    it 'throws not implemented error' do
      expect do
        facade.provision_extension(
          mockCourseId,
          mockStudentId,
          mockAssignmentId,
          mockDate
        )
      end.to raise_error(NotImplementedError)
    end
  end
end
