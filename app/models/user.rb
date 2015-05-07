class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :firstname, :lastname, :email, :password, :password_confirmation

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    firstname: "Nom",
    lastname: "Prénom",
    email: "Email"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :firstname, :lastname, presence: true
end
