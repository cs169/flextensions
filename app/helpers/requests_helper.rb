module RequestsHelper
  def text_label_for(request)
    "Request for #{request.user.try(:name) || 'N/A'} - #{request.assignment&.name || 'N/A'}"
  end

  def status_export_string(request)
    case request.status
    when 'pending'
      'Pending'
    when 'approved'
      if request.auto_approved
        "Auto Approved on #{request.updated_at.strftime('%a, %b %-d at %-I:%M%P')} by Auto Approval System"
      else
        "Approved on #{request.updated_at.strftime('%a, %b %-d at %-I:%M%P')} by #{request.last_processed_by_user&.name || 'Unknown'}"
      end
    when 'denied'
      "Denied on #{request.updated_at.strftime('%a, %b %-d at %-I:%M%P')} by #{request.last_processed_by_user&.name || 'Unknown'}"
    else
      'Unknown'
    end
  end
end
