class AddIndexes < ActiveRecord::Migration
  def change
    add_index :subscribers, :profile_id
    add_index :subscribers, :period_id
    add_index :subscribers, :msisdn

    add_index :registration_logs, :subscriber_id
    add_index :registration_logs, :profile_id
    add_index :registration_logs, :period_id

    add_index :message_logs, :sms_transaction_id
    add_index :message_logs, :subscriber_id
    add_index :message_logs, :profile_id
    add_index :message_logs, :period_id

    add_index :sms_transactions, :profile_id
  end
end
