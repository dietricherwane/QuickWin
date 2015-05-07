class MessageLogsController < ApplicationController
  prepend_before_filter :authenticate_user!

  layout "administrator"

  def list
    @transactions_active = "active"
    @transaction = SmsTransaction.find_by_id(params[:transaction_id])
    if @transaction.blank?
      render file: "#{Rails.root}/public/404.html", status: 404, layout: false
    else
      @message_logs = @transaction.message_logs
      @message_logs_count = @message_logs.count
      @message_logs = @message_logs.page(params[:page])
    end
  end
end
