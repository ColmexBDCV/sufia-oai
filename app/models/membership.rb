class Membership < ActiveRecord::Base
  MANAGER_LEVEL = 'Manager'.freeze
  CURATOR_LEVEL = 'Curator'.freeze
  DATA_ENTRY_LEVEL = 'DataEntry'.freeze

  class << self
    def levels
      [MANAGER_LEVEL, CURATOR_LEVEL, DATA_ENTRY_LEVEL]
    end
  end

  belongs_to :unit
  belongs_to :user

  validates :level, :user, :unit, presence: true
  validates :level, inclusion: { in: levels }
end
