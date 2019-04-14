class MessageLogsController < ApplicationController
  #prepend_before_filter :authenticate_user!

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

  def api_search
    @number = params[:msisdn]
    @login = params[:login]
    @password = params[:password]
    @service_id = params[:service_id]
    @begin_date = Date.parse(params[:begin_date]) rescue nil
    @end_date = Date.parse(params[:end_date]) rescue nil
    @service = Customer.where("login = ? AND status IS NOT FALSE AND label = ?", @login, @service_id).first rescue nil

    if !@service.blank?
      if @service.md5_password == @password #ActiveRecord::Base.connection.execute("select pgp_sym_decrypt('#{@service.password.force_encoding('iso8859-1').encode('utf-8')}', 'Pilote2017@key#')").first["pgp_sym_decrypt"] == @password[14, @password.length]
        validate_search_params
        set_query_params
      else
        # Invalid password
        @status = "2"
        @message = "Mot de passe invalide"
      end
    else
      # Service not found
      @status = "0"
      @message = "Service introuvable"
    end
    render text: %Q[{"status": "#{@status}"; "message": "#{@message}"; "log": "#{@log}"}]
  end

  def validate_search_params
    if @begin_date.blank? && @end_date.blank?
      @status => "3"
      @message = "Veuillez entrer une date"
    end
  end

  def set_query_params
    message_logs_query = ""
    transaction_logs_query = ""
    message_logs_query << "customer_id = #{@service.id}"
    message_logs_query << " AND msisdn LIKE '%#{@msisdn.strip}%'" if !@msisdn.blank?

    if !@begin_date.blank? and !@end_date.blank?
      message_logs_query << " AND created_at BETWEEN '#{@begin_date}' AND '#{@end_date}'"
    else
      message_logs_query << " AND created_at > '#{@begin_date}'" if !@begin_date.blank?
      message_logs_query << " AND created_at < '#{@end_date}'" if !@end_date.blank?
    end

    @message_logs = MessageLog.where(message_logs_query)

    if @message_logs.blank?
      @status = "4"
      @message = "Aucune donnée trouvée"
    else
      @status = "1"
      @message = %Q[#{@message_logs.count} messages trouvés"]
      @log = %Q["log": "#{MessageLog.all.map{|m| %Q{["message": "#{m.message}"; "msisdn": "#{m.msisdn}"; "date_envoi":"#{m.created_at}"]}}}]
    end
  end

end
