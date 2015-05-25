class CreateRegistrationLogs < ActiveRecord::Migration
  def change
    create_table :registration_logs do |t|
      t.integer :subscriber_id
      t.integer :profile_id
      t.integer :period_id

      t.timestamps
    end
  end
end
