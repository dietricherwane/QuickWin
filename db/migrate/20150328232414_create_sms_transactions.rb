class CreateSmsTransactions < ActiveRecord::Migration
  def change
    create_table :sms_transactions do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :profile_id
      t.text :description

      t.timestamps
    end
  end
end
