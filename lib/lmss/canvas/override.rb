module Lmss
  module Canvas
    class Override < BaseOverride
      attr_reader :id

      def initialize(data)
        @id = data.id
      end
    end
  end
end
