class ChangeMsisdnFieldSize < ActiveRecord::Migration
  def change
    remove_column :message_logs, :msisdn
    add_column :message_logs, :msisdn, :string
  end
end
