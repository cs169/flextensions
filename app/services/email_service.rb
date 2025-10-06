# frozen_string_literal: true

# A class for sending templated emails, using basic `{{variable}}` substitution.
class EmailService
  class << self
    # Given a subject_template and body_template (both strings
    # containing {{variable}} placeholders) plus a mapping
    # (e.g. { "student_name" => "Yaman", ... }),
    # returns a hash with :subject and :body filled in.
    def render_templates(subject_template, body_template, mapping)
      mapping.each_with_object(
        { subject: subject_template.dup, body: body_template.dup }
      ) do |(key, val), memo|
        placeholder = /{{\s*#{key}\s*}}/i
        memo[:subject].gsub!(placeholder, val.to_s)
        memo[:body].gsub!(placeholder, val.to_s)
      end
    end

    # Sends email now (or .deliver_later if you pass deliver_later: true).
    #
    # to:               recipient email
    # from:             sender   email
    # subject_template: e.g. "Extension for {{student_name}}"
    # body_template:    e.g.  course_settings.email_template
    # mapping:          { "student_name" => "Yaman", ... }
    def send_email(to:, from:, reply_to:, subject_template:, body_template:, mapping:, deliver_later: false)
      rendered = render_templates(subject_template, body_template, mapping)

      mail = ActionMailer::Base.mail(
        to: to,
        from: from,
        reply_to: reply_to,
        subject: rendered[:subject],
        body: rendered[:body].gsub("\n", "<br>\n"),
        content_type: 'text/html'
      )

      deliver_later ? mail.deliver_later : mail.deliver_now
    end
  end
end
