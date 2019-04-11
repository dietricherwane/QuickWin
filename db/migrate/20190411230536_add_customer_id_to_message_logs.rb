class AddCustomerIdToMessageLogs < ActiveRecord::Migration
  def change
    add_column :message_logs, :customer_id, :integer
  end
end
