class SearchController < ApplicationController
  include MessagesHelper

  #prepend_before_filter :authenticate_user!

  layout "administrator"

  def index
    init_search_form
  end

  def perform
    init_search_form
    init_messages

    @msisdn = params[:msisdn]
    @begin_date = Date.parse(params[:begin_date]) rescue nil
    @end_date = Date.parse(params[:end_date]) rescue nil

    @error = false

    validate_search_params

    set_query_params

    @error_message = messages!(@error_message, "error")

    if @error
      render :index
    else
      render :perform
    end
  end

  def init_search_form
    @search_active = true
  end

  def validate_search_params
    if @msisdn.blank? && @begin_date.blank? && @end_date.blank?
      @error = true
      @error_message << "Veuillez entrer au moins un terme de recherche.<br />"
    end
  end

  def set_query_params
    message_logs_query = ""
    transaction_logs_query = ""
    if !@msisdn.blank?
      message_logs_query << "msisdn LIKE '%#{@msisdn.strip}%'"
      if !@begin_date.blank? and !@end_date.blank?
        message_logs_query << " AND created_at BETWEEN '#{@begin_date}' AND '#{@end_date}'"
      else
        if !@begin_date.blank?
          message_logs_query << " AND created_at > '#{@begin_date}'"
        end
        if !@end_date.blank?
          message_logs_query << " AND created_at < '#{@end_date}'"
        end
      end
      @message_logs = MessageLog.where(message_logs_query)
      @message_logs_count = MessageLog.where(message_logs_query).count
      @message_logs = @message_logs.page(params[:page])
    else
      if !@begin_date.blank? and !@end_date.blank?
        transaction_logs_query << "created_at BETWEEN '#{@begin_date}' AND '#{@end_date}'"
      else
        if !@begin_date.blank?
          message_logs_query << " AND created_at > '#{@begin_date}'"
        end
        if !@end_date.blank?
          message_logs_query << " AND created_at < '#{@end_date}'"
        end
      end
      @transaction_logs = SmsTransaction.where(transaction_logs_query)
      @transaction_logs_count = SmsTransaction.where(transaction_logs_query).count
      @transaction_logs = @transaction_logs.page(params[:page])
    end

    if @message_logs.blank? && @transaction_logs.blank?
      @error = true
      @error_message << "Aucun résultat n'a été trouvé.<br />"
    end
  end

  def init_messages
    @error_message = ""
    @success_message = ""
  end
end
