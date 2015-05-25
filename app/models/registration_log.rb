class RegistrationLog < ActiveRecord::Base
  # Relationships
  belongs_to :subscriber
  belongs_to :profile
  belongs_to :period

  # Set accessible fields
  attr_accessible :subscriber_id, :msisdn, :profile_id, :period_id

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    subscriber_id: "Abonné",
    profile_id: "Profil",
    period_id: "Période de souscription"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :subscriber_id, :profile_id, :period_id, presence: true
end
