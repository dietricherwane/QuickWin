class Customer < ActiveRecord::Base
  has_many :sms_transactions
  # Set accessible fields
  attr_accessible :label, :uuid, :login, :password, :service_id, :sender, :user_id, :status, :id, :md5_password, :sms_provider_id, :bulk, :clear_password, :email
  #attr_encrypted :encrypted_password

  # Relationships
  belongs_to :user
  has_many :message_logs
  belongs_to :sms_provider
  has_many :sms_transactions
  has_many :profiles

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    user_id: "L'utilisateur",
    label: "Service ID",
    login: "Login",
    password: "Mot de passe",
    sender: "Emetteur du message",
    status: "Statut",
    sms_provider_id: "Fournisseur SMS",
    bulk: "Bulk SMS",
    clear_password: "Mot de passe"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :user_id, :label, :login, :password, :email, :sender, presence: true
  validates :email, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, multiline: true, allow_blank: false}
  validates :email, uniqueness: true
  validates :label, uniqueness: true
end
