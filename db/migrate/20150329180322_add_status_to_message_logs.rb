class AddStatusToMessageLogs < ActiveRecord::Migration
  def change
    add_column :message_logs, :status, :string, limit: 200
  end
end
