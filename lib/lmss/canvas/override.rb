module Lmss
  module Canvas
    class Override < BaseOverride
      attr_reader :id

      def initialize(data)
        raise NotImplementedError
      end
    end
  end
end
