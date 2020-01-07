class MessagesController < ApplicationController
  include MessagesHelper
  require 'roo'

  before_action :init_messages, only: [:send_message]
  prepend_before_filter :authenticate_user!, only: [:new, :send_message]

  layout "administrator"

  def new
    init_message_view
  end

  def send_message
    @profile_id = params[:post][:profile_id]
    @message = params[:post][:message]
    @number = params[:post][:custom_number]
    @subscribers_file = params[:post][:subscribers_file]
    @error = false

    validate_profile_id
    validate_message

    unless @error
      @profile = Profile.find_by_id(@profile_id)
      if @profile
        if @profile.name == "Numéro unique"
          validate_custom_number
        end
        if @profile.name == "Liste de numéros"
          validate_subscribers_file
        end
      end
    end

    unless @error
      @sent_messages = 0
      @failed_messages = 0
      deliver_messages
    end

    init_message_view

    @error_message = messages!(@error_message, "error")

    render :new
  end

  def filter_api_send_message
    @authentication_token = "0d1773a649e4c88bff44c49ec154615c"
    @message = params[:message]
    @number = params[:msisdn]
    @login = params[:login]
    @password = params[:password]
    @sender = params[:sender]
    @service_id = params[:service_id]
    @service = Customer.where("login = ? AND status IS NOT FALSE AND label = ?", @login, @service_id).first rescue nil

    #CustomLog.create(sender_service: "#{@sender.to_s} | #{@login.to_s} | #{@password.to_s}", message: params[:message], msisdn: params[:msisdn])

    if !@service.blank?
      if @service.md5_password == @password #ActiveRecord::Base.connection.execute("select pgp_sym_decrypt('#{@service.password.force_encoding('iso8859-1').encode('utf-8')}', 'Pilote2017@key#')").first["pgp_sym_decrypt"] == @password[14, @password.length]
        #@sender = @service.sender
        api_send_message
      else
        # Invalid password
        render text: "Invalid password"
      end
    else
      # Service not found
      render text: "Service not found"
    end
  end

  def api_send_message
    @profile = Profile.find_by_name("Numéro unique")
    @error = false
    @status = "0"


    if @authentication_token == "0d1773a649e4c88bff44c49ec154615c"
      validate_custom_number
      validate_message
    else
      @error = true
    end

    unless @error
      @sent_messages = 0
      @failed_messages = 0
      deliver_messages
    end

    render text: @status
  end

  def deliver_messages
    if @profile.name == "PMU"
      @subscribers = Subscriber.where("profile_id = #{Profile.pmu_profile_id} AND last_registration_date > TIMESTAMP '#{DateTime.now}' -  INTERVAL ' 1 day' * last_registration_period")
      set_transaction("Envoi de message aux abonnés du PMU.", @subscribers.count)
      deliver_generic_message
    end

    if @profile.name == "LOTO BONHEUR"
      @subscribers = Subscriber.where("profile_id = #{Profile.loto_bonheur_profile_id} AND last_registration_date > TIMESTAMP '#{DateTime.now}' -  INTERVAL ' 1 day' * last_registration_period")
      set_transaction("Envoi de message aux abonnés du LOTO BONHEUR.", @subscribers.count)
      deliver_generic_message
    end

=begin
    if @profile.name == "Quinté"
      @subscribers = Subscriber.where("profile_id = 1 AND last_registration_date > TIMESTAMP '#{DateTime.now}' -  INTERVAL ' 1 day' * last_registration_period")
      set_transaction("Envoi de message aux abonnés du Quinté.", @subscribers.count)
      deliver_generic_message
    end
=end

    if @profile.name == "Nouveaux inscrits"
      @subscribers = Subscriber.where("received_messages = NULL or received_messages = 0")
      set_transaction("Envoi de message aux nouveaux inscrits.", @subscribers.count)
      deliver_generic_message
    end

    if @profile.name == "Participants en cours"
      @subscribers = Subscriber.where("last_registration_date > TIMESTAMP '#{DateTime.now}' -  INTERVAL ' 1 day' * last_registration_period")
      set_transaction("Envoi de message aux partcipants en cours.", @subscribers.count)
      deliver_generic_message
    end

    if @profile.name == "Participants non actifs"
      @subscribers = Subscriber.where("last_registration_date < TIMESTAMP '#{DateTime.now}' -  INTERVAL ' 1 day' * last_registration_period")
      set_transaction("Envoi de message aux participants non actifs", @subscribers.count)
      deliver_generic_message
    end

    if @profile.name == "Numéro unique"
      set_transaction("Envoi de message à un numéro.", 1)
      send_message_request(@number.split.first)
      @transaction.update_attributes(ended_at: DateTime.now, send_messages: @sent_messages, failed_messages: @failed_messages)

      @success_message = messages!("Le message a été envoyé. Veuillez consulter l'état de l'envoi dans la liste des tansactions.", "success")
    end

    if @profile.name == "Liste de numéros"
      set_transaction("Envoi de message à une liste de numéros.", 0)
      deliver_message_to_excel_list
    end
  end

  def set_transaction(description, subscribers_count)
    @transaction = SmsTransaction.create(started_at: DateTime.now, profile_id: @profile.id, description: description, number_of_messages: subscribers_count, customer_id: (@service.id rescue nil))
  end

  # Handle message delivery for: PMU, LOTO BONHEUR, Nouveaux inscrits, Clients actifs, clients non actifs
  def deliver_generic_message
    unless @subscribers.blank?

      Thread.new do
        send_message_job(@subscribers)
        if (ActiveRecord::Base.connection && ActiveRecord::Base.connection.active?)
          ActiveRecord::Base.connection.close
        end
      end

      @success_message = messages!("Les messages ont été envoyés. Veuillez consulter l'état de l'envoi dans la liste des transactions.", "success")
    else
      @error_message << "Aucun message n'a été envoyé car il n'y avait aucun abonné dans la liste correspondant à vos critères.<br />"
    end
  end

  def deliver_message_to_excel_list
=begin
    #Thread.new do
=begin
      @spreadsheet = Spreadsheet.open(@subscribers_file.path).worksheet(0)
      @spreadsheet.each do |row|
        msisdn = row[0].to_s
        unless not_a_number?(msisdn) or msisdn.length < 11
          send_message_request(msisdn[-11,11])
        end
      end
=end
      @spreadsheet = Roo::Spreadsheet.open(@subscribers_file.tempfile, extension: :xlsx).sheet(0)
      puts "sheet opened"
      i = 1
      last_row = @spreadsheet.last_row + 1
      while i < last_row
        msisdn = @spreadsheet.cell(i,1).to_s
        unless not_a_number?(msisdn) or msisdn.length < 11
          send_message_request(msisdn[-11,11])
        end
        i += 1
      end
      @transaction.update_attributes(ended_at: DateTime.now, send_messages: @sent_messages, failed_messages: @failed_messages, number_of_messages: (@sent_messages + @failed_messages))
      if (ActiveRecord::Base.connection && ActiveRecord::Base.connection.active?)
        ActiveRecord::Base.connection.close
      end
    #end
    if (@sent_messages + @failed_messages) == 0
      @error_message << "Le fichier ne contenait aucun numéro valide.<br />"
    else
      @success_message = messages!("Veuillez consulter l'état de l'envoi dans la liste des transactions.", "success")
    end
  end

  def send_message_job(subscribers)
    #10.times do
      subscribers.each do |subscriber|
        @subscriber = subscriber
        send_message_request(@subscriber.msisdn)
      end
      @transaction.update_attributes(ended_at: DateTime.now, send_messages: @sent_messages, failed_messages: @failed_messages)
    #end
  end

  def send_message_request(msisdn)
    if msisdn.match(/\./)
      msisdn = "22" + msisdn[0..8]
    end
=begin
    request = Typhoeus::Request.new("http://smsplus3.routesms.com:8080/bulksms/bulksms?username=ngser1&password=abcd1234&type=0&dlr=1&destination=#{msisdn}&source=LONACI&message=#{URI.escape(@message)}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        result = response.body.strip.split("|") rescue nil
        if result[0] == "1701"
          @sent_messages += 1
          @transaction.message_logs.create(subscriber_id: (@subscriber.id rescue nil), msisdn: msisdn, profile_id: (@subscriber.profile_id rescue nil), period_id: (@subscriber.period_id rescue nil), message: @message, status: result[0], message_id: result[2])
          @sms_counter = SmsCounter.first
          if @sms_counter != blank?
            @sms_counter.update_attribute(:amount, (@sms_counter.amount - 1))
          end
        else
          @failed_messages += 1
          @transaction.message_logs.create(subscriber_id: (@subscriber.id rescue nil), msisdn: msisdn, profile_id: (@subscriber.profile_id rescue nil), period_id: (@subscriber.period_id rescue nil), message: @message, status: result[0])
        end
      end
    end

    request.run
=end
    parameter = Parameter.first

    case (parameter.sms_provider rescue nil)
    when "BICS"
      #send_with_bics(parameter, msisdn, @sender, @message)
    when "ROUTESMS"
      send_with_routesms(parameter, msisdn, (@sender rescue 'LONACI'), @message)
    when "INFOBIP"
      send_with_infobip(parameter, msisdn, (@sender rescue 'LONACI'), @message)
    else
      send_with_infobip(parameter, msisdn, (@sender rescue 'LONACI'), @message)
    end

    if @status == "1"
      @status = "1"
      @sent_messages += 1
      @transaction.message_logs.create(subscriber_id: (@subscriber.id rescue nil), msisdn: msisdn, profile_id: (@subscriber.profile_id rescue nil), period_id: (@subscriber.period_id rescue nil), message: @message, status: @request_status, message_id: @message_id, customer_id: (@service.id rescue nil), user_id: (@service.user.id rescue nil))
      # Décrémentation du compteur de SMS
      parameter.update_attributes(infobip_sms_counter: parameter.infobip_sms_counter - 1) rescue nil
    else
      @failed_messages += 1
      @transaction.message_logs.create(subscriber_id: (@subscriber.id rescue nil), msisdn: msisdn, profile_id: (@subscriber.profile_id rescue nil), period_id: (@subscriber.period_id rescue nil), message: @message, status: @request_status, customer_id: (@service.id rescue nil), user_id: (@service.user.id rescue nil))
    end
  end

  def send_with_infobip(parameter, msisdn, sender, message)
    sms_provider_url = parameter.infobip_provider_url rescue ''
    auth_header = Base64.encode64(parameter.infobip_provider_username + ":" + parameter.infobip_provider_password) rescue ''
    result = RestClient.post sms_provider_url, {'from' => "#{sender}", 'to' => "#{msisdn}", 'text' => "#{message}"}.to_json, {content_type: :json, accept: :json, :Authorization => "Basic #{auth_header}"}# rescue nil
    @request_status = JSON.parse(result)["messages"].first["status"]["groupName"] #rescue nil
    if @request_status == "ACCEPTED" || @request_status == "PENDING"
      @status = "1"
      @message_id = JSON.parse(result)["messages"].first["messageId"]
    else
      @status = "6"
    end
  end

  def send_with_routesms(parameter, msisdn, sender, message)
    request = Typhoeus::Request.new(parameter.routesms_provider_url.to_s + "?username=#{parameter.routesms_provider_username.to_s}&password=#{parameter.routesms_provider_password.to_s}&type=0&dlr=1&destination=#{msisdn.to_s}&source=LONACI&message=#{URI.escape(message)}", followlocation: true, method: :get)
    request.run
    result = request.response.body.strip.split("|") rescue nil
    @request_status = result[0]
    if @request_status == "1701"
      @status = "1"
      @message_id = result[2]
    else
      @status = "6"
    end
  end

  def validate_profile_id
    if @profile_id.blank?
      @error_message << "Le profil ne peut pas être vide.<br />"
      @error = true
    end
  end

  def validate_message
    if @message.blank?
      @error_message << "Le contenu du message ne peut pas être vide.<br />"
      @error = true
    end
  end

  def validate_custom_number
    if @number.blank? || not_a_number?(@number) || @number.length < 8 || @number.length > 13
      @error_message << "Veuillez entrer un numéro de téléphone valide.<br />"
      @error = true
    end
  end

  # Make sure the user uploads an xls or xlsx file
  def validate_subscribers_file
    if @subscribers_file.blank? || (@subscribers_file.content_type != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
      @error_message << "Veuillez choisir un fichier Excel 2007 contenant une liste de numéros.<br />"
      @error = true
    end
  end

  def init_messages
    @error_message = ""
    @success_message = ""
  end

  def init_message_view
    @message_active = "active exp"
    @message_current_id = "current"
    @new_message_active_subclass = "this"

    @profiles = Profile.where("published IS NOT FALSE")
  end
end
