module MessagesHelper
  def flash_class(level)
    case level
    when "notice" then "nNote nInformation hideit"
    when "success" then "nNote nSuccess hideit"
    when "error" then "nNote nFailure hideit"
    when "alert" then "nNote nWarning hideit"
    end
  end

  def messages!(notification_message, key)
    return "" if notification_message.blank?

    html = <<-HTML
      <div class="#{flash_class(key)}">
        <p><strong>#{notification_message}</strong></p>
      </div>
    HTML

    html.html_safe
  end
end
