class AddInfobipParametersToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :infobip_provider_url, :string
    add_column :parameters, :infobip_provider_username, :string
    add_column :parameters, :infobip_provider_password, :string
  end
end
