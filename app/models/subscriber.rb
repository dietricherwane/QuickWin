class Subscriber < ActiveRecord::Base
    # Relationships
    belongs_to :profile
    belongs_to :period
    has_many :registration_logs
    has_many :message_logs

    # Set accessible fields
    attr_accessible :name, :msisdn, :profile_id, :period_id, :last_registration_date, :last_registration_period, :registrations_times, :received_messages, :published

    # Renaming attributes into more friendly text
    HUMANIZED_ATTRIBUTES = {
      name: "Nom",
      msisdn: "MSISDN",
      profile_id: "Profil",
      period_id: "Période",
      last_registration_date: "Date du dernier enregistrement",
      last_registration_period: "Dernière période d'enregistrement",
      registration_times: "Nombre de participations",
      received_messages: "Messages reçus",
      created_at: "Date du premier enregistrement"
    }

    def self.human_attribute_name(attr, option = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    # Validations
    #validates :msisdn, :profile_id, :period_id, presence: true
    #validates :name, length: {minimum: 3, maximum: 100, allow_blank: true}
    #validates :msisdn, uniqueness: true
end
