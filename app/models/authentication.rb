class Authentication < ApplicationRecord
    def access_token
      self.bcourse_token
    end
end