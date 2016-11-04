class GenericWork < ActiveFedora::Base
  include CurationConcerns::WorkBehavior
  include CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  include WorkMetadata
  include PhysicalMediaMetadata
  include ManagedByUnit

  self.human_readable_type = 'Work'

  validates :unit, presence: { message: 'must belong to a unit.' }
  validates :unit, inclusion: { in: ->(_obj) { Unit.pluck(:key) } }

  after_save :update_file_sets

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your work must have a title.' }

  def to_solr
    super.merge!(materials_and_measurements_to_solr)
  end

  private

  def update_file_sets
    file_sets.each(&:save!)
  end
end
