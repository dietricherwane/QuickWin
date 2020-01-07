class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :sms_provider
      t.string :sms_sender

      t.timestamps
    end
  end
end
