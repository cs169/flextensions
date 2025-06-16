module Lmss
  class BaseAssignment
    def id = raise(NotImplementedError)
    def name = raise(NotImplementedError)
    def due_date = raise(NotImplementedError)
    def late_due_date = raise(NotImplementedError)

    def extend(**_kwargs)
      raise NotImplementedError, "#{self.class} must implement #extensions"
    end

    def to_lms_assignment
      Lmss::BaseAssignment.new(
        id: id,
        name: name,
        due_date: due_date,
        late_due_date: late_due_date
      )
    end
  end
end
