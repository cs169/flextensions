module Lmss
  module Gradescope
    def self.login(email, password)
      Client.new.tap { |client| client.login(email, password) }
    end
  end
end
