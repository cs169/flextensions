
# Canvas
Lms.find_or_create_by!(id: 1, lms_name: 'Canvas', use_auth_token: true)

# Gradescope
Lms.find_or_create_by!(id: 2, lms_name: 'Gradescope', use_auth_token: false)

# A special user to track auto-approvals of requests.
User.find_or_create_by!(
  email: SystemUserService::AUTO_APPROVAL_EMAIL,
  name: SystemUserService::AUTO_APPROVAL_NAME,
  canvas_uid: SystemUserService::AUTO_APPROVAL_UID
)
