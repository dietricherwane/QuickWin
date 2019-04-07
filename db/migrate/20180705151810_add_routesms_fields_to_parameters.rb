class AddRoutesmsFieldsToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :routesms_provider_url, :string
    add_column :parameters, :routesms_provider_username, :string
    add_column :parameters, :routesms_provider_password, :string
  end
end
