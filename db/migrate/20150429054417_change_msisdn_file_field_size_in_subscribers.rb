class ChangeMsisdnFileFieldSizeInSubscribers < ActiveRecord::Migration
  def change
    remove_column :subscribers, :msisdn
    add_column :subscribers, :msisdn, :string
  end
end
