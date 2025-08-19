# Ensure all LMS integrations are set up
# Some of this code arguably belongs in a seeds file, but that is OK.

Rails.application.config.after_initialize do
  CANVAS_LMS_ID = 1
  GRADESCOPE_LMS_ID = 2
  CANVAS_LMS = Lms.find_or_create_by(id: CANVAS_LMS_ID, lms_name: 'Canvas', use_auth_token: true)
  GRADESCOPE_LMS = Lms.find_or_create_by(id: GRADESCOPE_LMS_ID, lms_name: 'Gradescope', use_auth_token: false)
end
