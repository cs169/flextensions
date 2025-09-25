module Lmss
  class BaseOverride
    def id = raise(NotImplementedError)
    def student_id = raise(NotImplementedError)
    def override_release_date = raise(NotImplementedError)
    def override_due_date = raise(NotImplementedError)
    def override_late_due_date = raise(NotImplementedError)
  end
end
