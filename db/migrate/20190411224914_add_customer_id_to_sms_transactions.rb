class AddCustomerIdToSmsTransactions < ActiveRecord::Migration
  def change
    add_column :sms_transactions, :customer_id, :integer
  end
end
