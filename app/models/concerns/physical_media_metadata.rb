module PhysicalMediaMetadata
  extend ActiveSupport::Concern

  included do
    has_many :materials, class_name: "Osul::VRA::Material", predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf
    has_many :measurements, class_name: "Osul::VRA::Measurement", predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf

    accepts_nested_attributes_for :materials, allow_destroy: true
    accepts_nested_attributes_for :measurements, allow_destroy: true
  end

  private

  def materials_and_measurements_to_solr
    measurement_hash = { "measurement_tesim" => [], "measurement_sim" => [] }
    measurements.each do |m|
      measurement = [m.measurement.try(:to_s), m.measurement_type, m.measurement_unit].reject(&:blank?).join(" ")
      measurement_hash["measurement_tesim"] << measurement
      measurement_hash["measurement_sim"] << measurement
    end

    material_hash = { "material_tesim" => [], "material_sim" => [] }
    materials.each do |m|
      material = [m.material.try(:to_s), m.material_type.try(:to_s)].reject(&:blank?).join(", ")
      material_hash["material_tesim"] << material
      material_hash["material_sim"] << material
    end

    material_hash.merge!(measurement_hash)
  end
end
