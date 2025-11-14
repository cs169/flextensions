# Ensure all LMS integrations are set up
# TODO: This no longer ensures all LMS integrations are set up.
# Updating `Lms` here breaks when there are migrations pending.
Rails.application.config.after_initialize do
  CANVAS_LMS_ID = 1
  GRADESCOPE_LMS_ID = 2
end
