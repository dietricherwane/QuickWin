class CreateSmsProviders < ActiveRecord::Migration
  def change
    create_table :sms_providers do |t|
      t.string :name, limit: 100
      t.string :url, limit: 200

      t.timestamps
    end
  end
end
