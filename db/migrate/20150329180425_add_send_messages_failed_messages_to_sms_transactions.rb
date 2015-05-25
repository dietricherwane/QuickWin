class AddSendMessagesFailedMessagesToSmsTransactions < ActiveRecord::Migration
  def change
    add_column :sms_transactions, :send_messages, :bigint
    add_column :sms_transactions, :failed_messages, :bigint
  end
end
