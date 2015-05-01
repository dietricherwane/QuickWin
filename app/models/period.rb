class Period < ActiveRecord::Base
  # Relationships
  has_many :subscribers

  # Set accessible fields
  attr_accessible :name, :number_of_days, :published

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    name: "Nom",
    number_of_days: "Nombre de jours"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :name, :number_of_days, presence: true
  validates :number_of_days, numericality: {greater_than: 1}
  validates :name, :number_of_days, uniqueness: true
end
