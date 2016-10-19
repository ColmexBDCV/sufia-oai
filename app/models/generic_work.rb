# Generated via
#  `rails generate curation_concerns:work GenericWork`
class GenericWork < ActiveFedora::Base
  include CurationConcerns::WorkBehavior
  include CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  include WorkMetadata
  include PhysicalMediaMetadata

  belongs_to :admin_policy, predicate: ActiveFedora::RDF::ProjectHydra.isGovernedBy

  self.human_readable_type = 'Work'

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your work must have a title.' }
  validates :unit, presence: { message: 'Your work must belong to a unit.' }
  validates :unit, inclusion: { in: ->(_obj) { Unit.pluck(:key) } }

  before_save :set_admin_policy

  def responsible_unit
    Unit.find_by_key(unit)
  end

  def to_solr
    super.merge!(materials_and_measurements_to_solr)
  end

  private

  def set_admin_policy
    self.admin_policy = responsible_unit.admin_policy
  end
end
