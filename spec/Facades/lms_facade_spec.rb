require 'rails_helper'

describe LmsFacade do
  let(:facade) { described_class.new }
  let(:mockCourse) { 16 }
  let(:mockStudent) { 22 }
  let(:mockAssignment) { 18 }
  let(:mockDate) { '2002-03-16:16:00:00Z' }

  describe 'provision_extension' do
    it 'throws not implemented error' do
      expect do
        facade.provision_extension(
          mockCourse,
          mockStudent,
          mockAssignment,
          mockDate
        )
      end.to raise_error(NotImplementedError)
    end
  end
end
