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
    [:idpersona, :contributor_conacyt, :coverage, :creator_conacyt, :date, :description, :format, :identifier, :language, :publisher, :relation, :rights, :source, :title, :type, :access, :audience]
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
          elsif field == :identifier
              #xml.tag! "dc:#{field}", "http://repositorio.colmex.mx/concern/generic_works/#{representative_id}"
          elsif field == :title
            xml.tag! "dc:identifier", "http://repositorio.colmex.mx/concern/generic_works/#{id}"
            unless collection_name.nil?
              collection_name.each do |value|
                xml.tag! "dc:subject", "info:eu-repo/classification/cti/#{value}"
              end
            end
            # end
            xml.tag! "dc:#{field}", v
          # elsif field == :subject
          #   valor = add_sc(field, v, xml)
          #   xml.tag! "dc:subject", "info:eu-repo/semantics/#{valor}"
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

  def add_sc(collection_name, xml)
    #return unless respond_to?("collection_name")
    #return if collection_name.nil?
  end

  def add_identifiers(field, v, xml)
    # orcid_value = add_orcid
    # cvu_value = add_cvu
    hash = parse_conacyt(v)
    if hash.key?('curp')
      identifier = "info:eu-repo/dai/mx/curp/#{hash['curp']}"
    end
    if hash.key?('idCvuConacyt')
      identifier = "info:eu-repo/dai/mx/cvu/#{hash['idCvuConacyt']}"
    end
    if hash.key?('idOrcid')
      identifier = "info:eu-repo/dai/mx/orcid/#{hash['idOrcid']}"
    end
    name = "#{hash['nombres']} #{hash['primerApellido']}"
    if hash.key?('segundoApellido')
      name += " #{hash['segundoApellido']}"
    end

    if field == :creator_conacyt
      unless identifier.nil?
        xml.tag!("dc:creator", name, id:identifier)
      else
        xml.tag! "dc:creator", name
      end
    end
    if field == :contributor_conacyt
      unless identifier.nil?
        xml.tag!("dc:contributor", name, id:identifier)
      else
        xml.tag! "dc:contributor", name
      end
    end

  end

  def parse_conacyt(v)
    array = v.split("\n")

    value = {}

    array.each do |a|

      b = a.split(": ")

      value[b[0]] = b[1]

    end

    return value

  end

  def dublin_core_field_name? field
    dublin_core_field_names.include? field.to_sym
  end
end
