class SmsCountersController < ApplicationController

  layout "administrator"

  def index
    @sms_counter = SmsCounter.first

    if @sms_counter.blank?
      @sms_counter = SmsCounter.create(amount: 0)
    end
  end

  def update
    SmsCounter.first.update_attribute(:amount, (params[:post][:custom_number].to_i rescue 0))

    redirect_to sms_counter_path
  end

end
