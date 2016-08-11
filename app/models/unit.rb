class Unit < ActiveRecord::Base
  validates :name, :key, presence: true
end
