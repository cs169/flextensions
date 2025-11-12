# frozen_string_literal: true

require 'securerandom'
require 'active_support/core_ext/object/blank'

module CanvasSpecHelpers
  def build_canvas_assignment(attrs = {})
    defaults = {
      'id' => SecureRandom.uuid,
      'name' => 'Sample Assignment',
      'due_at' => '2025-01-15T23:59:00Z',
      'lock_at' => nil,
      'all_dates' => []
    }

    assignment_data = defaults.merge(attrs.transform_keys(&:to_s))

    assignment_data['base_date'] ||= derive_base_date(assignment_data)

    Lmss::Canvas::Assignment.new(assignment_data)
  end

  private

  def derive_base_date(assignment_data)
    base_due = assignment_data['due_at']
    base_lock = assignment_data['lock_at']
    return nil if base_due.nil? && base_lock.nil?

    base_hash = {}
    base_hash['due_at'] = base_due if base_due
    base_hash['lock_at'] = base_lock if base_lock
    base_hash['base'] = true unless base_hash.empty?
    base_hash.presence
  end
end

RSpec.configure do |config|
  config.include(CanvasSpecHelpers)
end
