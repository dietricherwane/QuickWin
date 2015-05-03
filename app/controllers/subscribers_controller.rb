class SubscribersController < ApplicationController
  include MessagesHelper

  layout "administrator"

  def pmu
    subscribers_per_profile("PMU")
    @pmu_active_subclass = "this"
  end

  def loto_bonheur
    subscribers_per_profile("LOTO BONHEUR")
    @loto_bonheur_active_subclass = "this"
  end

  def subscribers_per_profile(profile)
    @profile_active = "active exp"
    @profile_current_id = "current"
    profile = Profile.find_by_name(profile)

    if profile
      @subscribers = Subscriber.where("profile_id = #{profile.id}").order("last_registration_date DESC")
      @subscribers_count = @subscribers.count
      @subscribers = @subscribers.page(params[:page])
    end
  end

  def load_list
    @profile_active = "active exp"
    @profile_current_id = "current"
    @load_subscribers_active_subclass = "this"
  end

  def load_excel_list
    @error_message = ""
    inserted = false
    @subscribers_file = params[:subscribers_file]
    validate_subscribers_file

    unless @error
      @spreadsheet = Spreadsheet.open(@subscribers_file.path).worksheet(0)
      @spreadsheet.each do |row|
        @name = row[0].to_s.strip
        @msisdn = row[1].to_s.strip[-11,11]
        @profile = row[2].to_s.strip.downcase
        @period = row[3].to_s.strip

        validate_msisdn
        validate_profile
        validate_period

        unless @error
          inserted = true
          @subscriber = Subscriber.find_by_msisdn(@msisdn)
          if @subscriber
            profile_id = Profile.find_by_name(@profile).id
            period_id = Period.find_by_number_of_days(@period.to_i).id
            @subscriber.update_attributes(name: @name, profile_id: profile_id, period_id: period_id, last_registration_date: DateTime.now, last_registration_period: @period, registrations_times: (@subscriber.registrations_times + 1))
          else
            @subscriber = Subscriber.create(name: @name, msisdn: @msisdn, profile_id: Profile.find_by_name(@profile).id, period_id: Period.find_by_number_of_days(@period.to_i), last_registration_date: DateTime.now, last_registration_period: @period, registrations_times: 1)
          end
          RegistrationLog.create(subscriber_id: @subscriber.id, profile_id: profile_id, period_id: period_id)
        end
      end
    end

    if inserted
      @success_message = messages!("Le fichier a été chargé en base.", "success")
    else
      @error_message << "Aucun compte n'a été inséré en base.<br />"
      @error_message = messages!(@error_message, "error")
    end

    render :load_list
  end

  # Make sure the user uploads an xls or xlsx file
  def validate_subscribers_file
    if @subscribers_file.blank? || (@subscribers_file.content_type != "application/vnd.ms-excel" && @subscribers_file.content_type != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
      @error_message << "Veuillez choisir un fichier Excel contenant une liste de numéros.<br />"
      @error = true
    end
  end

  def validate_msisdn
    if @msisdn.blank? || not_a_number?(@msisdn) || @msisdn.length < 8 || @msisdn.length > 13
      @error = true
    end
  end

  def validate_profile
    case @profile
      when "pmu"
        @profile = "PMU"
      when "loto bonheur"
        @profile = "LOTO BONHEUR"
      else
        @error = true
      end
  end

  def validate_period
    if not_a_number?(@period) || ![1, 7, 30].include?(@period.to_i)
      @error = true
    end
  end

end
