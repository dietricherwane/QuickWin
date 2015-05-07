module DeviseHelper
  # A simple way to show error messages for the current devise resource. If you need
  # to customize this method, you can either overwrite it in your application helpers or
  # copy the views to your application.
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| msg + "<br />" }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    # Get current layout and name notification class accordingly
    #controller.send(:_layout) == "sessions" ? @notification_class = "session_notification" : @notification_class = "notification"

    html = <<-HTML
      <div class="nNote nFailure hideit">
        <p><strong>#{messages}</strong></p>
      </div>
    HTML

    html.html_safe
  end
end
