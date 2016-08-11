class Unit < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  validates :name, :key, presence: true
end
