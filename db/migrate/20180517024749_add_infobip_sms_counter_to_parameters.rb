class AddInfobipSmsCounterToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :infobip_sms_counter, :integer
  end
end
