# TODO: We need to redo the way data is seeded.

# Canvas
Lms.find_or_create_by!(id: 1) do |lms|
  lms.lms_name = 'Canvas'
  lms.use_auth_token = true
end

# Gradescope
Lms.find_or_create_by!(id: 2) do |lms|
  lms.lms_name = 'Gradescope'
  lms.use_auth_token = false
end
