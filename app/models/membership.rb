class Membership < ActiveRecord::Base
  belongs_to :unit
  belongs_to :user

  validates :level, :user, :unit, presence: true
end
