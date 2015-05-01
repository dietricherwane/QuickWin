class AddMessageIdToMessageLogs < ActiveRecord::Migration
  def change
    add_column :message_logs, :message_id, :string, limit: 200
  end
end
