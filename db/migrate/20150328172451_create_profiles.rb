class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name, limit: 100
      t.boolean :published

      t.timestamps
    end
  end
end
