class AddNumberOfMessagesToSmsTransactions < ActiveRecord::Migration
  def change
    add_column :sms_transactions, :number_of_messages, :bigint
  end
end
