class Profile < ActiveRecord::Base
  # Relationships
  has_many :subscribers
  has_many :sms_transactions

  # Set accessible fields
  attr_accessible :name, :published

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    name: "Nom"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: true

  # Custom functions
  def self.pmu_profile_id
    where(name: "PMU").first.id rescue nil
  end

  def self.loto_bonheur_profile_id
    where(name: "LOTO BONHEUR").first.id rescue nil
  end
end
