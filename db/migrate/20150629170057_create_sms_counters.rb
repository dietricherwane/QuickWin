class CreateSmsCounters < ActiveRecord::Migration
  def change
    create_table :sms_counters do |t|
      t.integer :amount

      t.timestamps
    end
  end
end
