class CreateMessageLogs < ActiveRecord::Migration
  def change
    create_table :message_logs do |t|
      t.integer :subscriber_id
      t.string :msisdn, limit: 8
      t.integer :profile_id
      t.integer :period_id
      t.integer :sms_transaction_id
      t.text :message

      t.timestamps
    end
  end
end
