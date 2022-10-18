class Property < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many_attached :picture
  #before_save :approved_property
  # validates :appartment_name,:price, presence: true
  # validates :bathrooms, comparison: { greater_than_or_equal_to: 0 }
  # validates :bedrooms, comparison: { greater_than_or_equal_to: 0}
  # validates :price, comparison: { greater_than: 0}

  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

  def self.active
    where(status: "active")
  end

  def self.archived
    where(status: "archived")
  end

  def active?
    status == "active"
  end

  def archived?
    status == "archived"
  end
end
