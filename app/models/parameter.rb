class Parameter < ActiveRecord::Base
  attr_accessible :sms_provider, :infobip_provider_username, :infobip_provider_password, :infobip_provider_url, :infobip_sms_counter, :routesms_provider_url, :routesms_provider_username, :routesms_provider_password
end
