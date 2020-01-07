class AddClearPasswordToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :clear_password, :string
  end
end
