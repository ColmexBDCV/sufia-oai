# frozen_string_literal: true
require 'builder'

# This module provide Dublin Core export based on the document's semantic values
module Blacklight::Document::DublinCore

  def self.extended(document)
    # Register our exportable formats
    Blacklight::Document::DublinCore.register_export_formats( document )
  end

  def self.register_export_formats(document)
    document.will_export_as(:xml)
    document.will_export_as(:dc_xml, "text/xml")
    document.will_export_as(:oai_dc_xml, "text/xml")
  end

  def dublin_core_field_names
    [:contributor_conacyt, :coverage, :creator_conacyt, :date, :description, :format, :identifier, :language, :publisher, :relation, :rights, :source, :subject_conacyt, :title, :type, :access]
  end

  # dublin core elements are mapped against the #dublin_core_field_names whitelist.
  def export_as_oai_dc_xml
    xml = Builder::XmlMarkup.new
    xml.tag!("oai_dc:dc",
             'xmlns:oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/",
             'xmlns:dc' => "http://purl.org/dc/elements/1.1/",
             'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
             'xsi:schemaLocation' => %(http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd)) do
      to_semantic_values.select { |field, values| dublin_core_field_name? field }.each do |field, values|
        Array.wrap(values).each do |v|
          if field == :creator_conacyt || field == :contributor_conacyt
            # end xml looks like this: <dc:creator id="repositorio.colmex.mx/orcid/123456">Cervantes</dc:creator>
            add_identifiers(field, v, xml)
          elsif field == :access
            add_access_rights(field, v, xml)
          elsif field == :subject_conacyt
              xml.tag! "dc:subject", v
          else
            xml.tag! "dc:#{field}", v
          end
        end
      end
    end
    xml.target!
  end

  alias_method :export_as_xml, :export_as_oai_dc_xml
  alias_method :export_as_dc_xml, :export_as_oai_dc_xml

  # we need to add a metadata xml tag for access type
  def add_access_rights(field, v, xml)
    value = ""
    if v == "restricted"
      value = "restrictedAccess"
    elsif v == "open"
      value = "openAccess"
    elsif v == "embargoed"
      value = "embargoedAccess"
    else
      value = "closedAccess"
    end

    xml.tag! "dc:rights", "info:eu-repo/semantics/#{value}"
  end

  private

  def add_identifiers(field, v, xml)
    # orcid_value = add_orcid
    # cvu_value = add_cvu
    if field == :creator_conacyt
      orcid_value = check_field("orcid")
      cvu_value = check_field("cvu")
      if cvu_value.nil? && orcid_value.nil?
        xml.tag! "dc:creator", v
      elsif cvu_value.present? && orcid_value.present?
        xml.tag!("dc:creator", v, id: "info:eu-repo/dai/mx/orcid/#{orcid_value}")
      elsif orcid_value.nil?
        xml.tag!("dc:creator", v, id: "info:eu-repo/dai/mx/cvu/#{cvu_value}")
      else
        xml.tag!("dc:creator", v, id: "info:eu-repo/dai/mx/orcid/#{orcid_value}")
      end
    end
    if field == :contributor_conacyt
      contributor_orcid_value = check_field("contributor_orcid")
      contributor_cvu_value = check_field("contributor_cvu")
      if contributor_cvu_value.nil? && contributor_orcid_value.nil?
        xml.tag! "dc:contributor", v
      elsif contributor_cvu_value.present? && contributor_orcid_value.present?
        xml.tag!("dc:contributor", v, id: "info:eu-repo/dai/mx/orcid/#{contributor_orcid_value}")
      elsif contributor_orcid_value.nil?
        xml.tag!("dc:contributor", v, id: "info:eu-repo/dai/mx/cvu/#{contributor_cvu_value}")
      else
        xml.tag!("dc:contributor", v, id: "info:eu-repo/dai/mx/orcid/#{contributor_orcid_value}")
      end
    end

  end

  def add_orcid
    return unless respond_to?("orcid")
    return if orcid.nil?
    send("orcid").first
  end

  def add_cvu
    return unless respond_to?("cvu")
    return if cvu.nil?
    send("cvu").first
  end

  def check_field(campo)
    return unless respond_to?(campo)
    return if campo.nil?
    send(campo)
  end

  def dublin_core_field_name? field
    dublin_core_field_names.include? field.to_sym
  end
end
