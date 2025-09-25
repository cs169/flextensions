module Lmss
  class BaseAssignment
    def id = raise(NotImplementedError)
    def name = raise(NotImplementedError)
    def due_date = raise(NotImplementedError)
    def late_due_date = raise(NotImplementedError)
  end
end
