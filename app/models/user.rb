class User < ApplicationRecord
  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :image
  has_many :properties, dependent: :destroy
  after_create :assign_default_role
  scope :find_name, -> {where("name = ?",'Sharad Yadav')}

  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end
  
end
