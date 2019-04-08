class CustomersController < ApplicationController
  include MessagesHelper

  before_action :init_customer_view, only: [:new, :list]
  #prepend_before_filter :authenticate_user!, only: [:new, :create]

  layout :select_layout

  def select_layout
    case session[:customer]
    when nil
        return "administrator"
      else
        return "customer"
    end
  end

  def new
    @customer = current_user.customers.new()
    @sms_providers = SmsProvider.all
    @customer_exists = (current_user.customers.count == 0 ? false : true)
  end

  def create
    init_customer_view
    @error_message = ""
    @success_message = ""
    @existing_customer = current_user.customers.first rescue nil
    @sms_providers = SmsProvider.all

    @customer = Customer.new(params[:customer].merge({user_id: current_user.id, md5_password: Digest::MD5.hexdigest(params[:customer][:password]), clear_password: params[:customer][:password]}))

    if params[:customer][:password] =! params[:password_confirmation]
      @error_message = "Le mot de passe et sa confirmation doivent être identiques<br />"
      @error_message = messages!(@error_message + @customer.errors.full_messages.map { |msg| "#{msg}<br />" }.join, "error")
    else
      if @customer.save &&  @error_message.blank?
        #if @existing_customer.blank?
          ActiveRecord::Base.connection.execute("UPDATE customers SET password = '#{Digest::MD5.hexdigest(@customer.password + 'Pilote2017@key#')}' WHERE id = #{@customer.id}")# rescue nil
          #CustomerMailer.welcome_email(@customer).deliver
          #ActiveRecord::Base.connection.execute("UPDATE customers SET password = pgp_sym_encrypt('#{Digest::MD5.hexdigest(@customer.password)}', 'Pilote2017@key#') WHERE id = '#{@customer.id}'")# rescue nil
        #else
          #ActiveRecord::Base.connection.execute("UPDATE customers SET password = '#{@existing_customer.password}', login = '#{@existing_customer.login}' WHERE user_id = #{current_user.id}")# rescue nil
        #end
        @success_message = messages!("Le client a été correctement créé", "success")
        @customer = current_user.customers.new()
      else
        @error_message = messages!(@error_message + @customer.errors.full_messages.map { |msg| "#{msg}<br />" }.join, "error")
      end
    end

    render :new
  end

  def list
    init_list_customer_view
    @customers = Customer.all.order("id DESC").page(params[:page])
    @customers_count = @customers.count
  end

  def edit
    @customer = Customer.where("id = #{params[:customer_id]}").first rescue nil

    if @customer.blank?
      @error_message = messages!("Le client n'a pas été trouvé", "error")
      render :list
    end
  end

  def update
    @error_message = ""
    @password = params[:customer][:password]
    @password_confirmation = params[:password_confirmation]
    @customer = Customer.where("id = #{params[:customer][:id]}").first rescue nil
    customer_params = params[:customer]
    init_list_customer_view
    if @customer.blank?
      @error_message = messages!("Le client n'a pas été trouvé", "error")
      render :list
    else
      if !@password.blank? || !@password_confirmation.blank?
        unless @password == @password_confirmation
          @error_message = messages!("Le mot de passe et sa confirmation doivent être identiques<br />", "error")
        end
      else
        customer_params.except!(:password, :id)
      end

      if @error_message.blank?
        if @customer.update_attributes(customer_params)
          ActiveRecord::Base.connection.execute("UPDATE customers SET password = '#{Digest::MD5.hexdigest(@customer.password + 'Pilote2017@key#')}', md5_password = '#{Digest::MD5.hexdigest(@customer.password)}', clear_password = '#{params[:customer][:password]}' WHERE id = '#{@customer.id}'") rescue nil
          @success_message = messages!("Le profil du client: #{@customer.label} a été mis à jour", "success")
        else
          @error_message = messages!(@error_message + @customer.errors.full_messages.map { |msg| "#{msg}<br />" }.join, "error")
        end
      end
    end

    render :edit
  end

  def disable
    disable_enable(params[:customer_id], false, "désactivé")
  end

  def enable
    disable_enable(params[:customer_id], true, "activé")
  end

  def disable_enable(customer_id, status, status_text)
    @customers = Customer.all.order("id DESC").page(params[:page])
    @customer = Customer.where("id = #{customer_id}").first rescue nil
    init_list_customer_view

    if @customer.blank?
      @error_message = messages!("Le client n'a pas été trouvé", "error")
    else
      @customer.update_attributes(status: status)
      @success_message = messages!("Le client a été correctement #{status_text}", "success")
    end

    render :list
  end

  def init_customer_view
    @customer_active = "active exp"
    @customer_current_id = "current"
    @new_customer_active_subclass = "this"
  end

  def init_list_customer_view
    @customer_active = "active exp"
    @customer_current_id = "current"
    @list_customers_active_subclass = "this"
  end
end
