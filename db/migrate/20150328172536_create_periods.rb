class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :name, limit: 100
      t.integer :number_of_days

      t.timestamps
    end
  end
end
