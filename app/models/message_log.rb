class MessageLog < ActiveRecord::Base
  # Relationships
  belongs_to :subscriber
  belongs_to :profile
  belongs_to :period
  belongs_to :sms_transaction

  # Set accessible fields
  attr_accessible :subscriber_id, :msisdn, :profile_id, :period_id, :message, :sms_transaction_id, :status, :message_id, :created_at

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    subscriber_id: "Abonné",
    msisdn: "MSISDN",
    profile_id: "Profil",
    period_id: "Période de souscription",
    message: "Message",
    sms_transaction_id: "Transaction",
    status: "Statut de l'envoi",
    message_id: "Id du message"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  #validates :msisdn, :profile_id, :period_id, presence: true
end
