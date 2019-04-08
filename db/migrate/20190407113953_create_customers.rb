class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :label
      t.string :uuid
      t.string :login
      t.string :password
      t.string :service_id
      t.string :encrypted_password
      t.string :iv
      t.string :key
      t.string :bytea_password
      t.integer :user_id
      t.string :sender
      t.boolean :status
      t.string :md5_password
      t.integer :sms_provider_id
      t.integer :bulk

      t.timestamps
    end
  end
end
