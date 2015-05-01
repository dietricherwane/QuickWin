class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :name, limit: 100
      t.string :msisdn, limit: 8
      t.integer :profile_id
      t.integer :period_id
      t.datetime :last_registration_date
      t.integer :last_registration_period
      t.integer :registrations_times
      t.integer :received_messages
      t.boolean :published

      t.timestamps
    end
  end
end
