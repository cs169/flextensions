# Ensure all LMS integrations are set up

Rails.application.config.after_initialize do
  CANVAS_LMS_ID = 1
  GRADESCOPE_LMS_ID = 2

  begin
    next unless ActiveRecord::Base.connection.table_exists?('lmss')
    # Warm the tiny cache.
    Lms.CANVAS_LMS
    Lms.GRADESCOPE_LMS
  rescue ActiveRecord::NoDatabaseError
    # Skip if database doesn't exist
    next
  end
end
