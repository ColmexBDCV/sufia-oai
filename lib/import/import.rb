module MyImport
  class ImportSettings
    attr_reader :sufia6_user, :sufia6_password, :sufia6_fedora_root_uri, :sufia6_root_uri

    def initialize(sufia6_user, sufia6_password, sufia6_fedora_root_uri, sufia6_root_uri)
      @sufia6_user = sufia6_user
      @sufia6_password = sufia6_password
      @sufia6_fedora_root_uri = sufia6_fedora_root_uri
      @sufia6_root_uri = sufia6_root_uri
    end
  end

  class ImportFileSet
    def initialize(settings)
      @settings = settings
    end

    def image_exists?(id)
      require "net/http"
      content_uri = "#{@settings.sufia6_fedora_root_uri}/#{ActiveFedora::Noid.treeify(id)}/content"
      url = URI.parse(content_uri)
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
      return true if res.code == "200"
      false
    end

    def from_gf(gf, depositor)
      Rails.logger.debug "Creating FileSet for  generic_file_id #{gf.fid}.."
      fs = FileSet.new
      fs.title << gf.title
      # Where did the filename property go?
      # fs.filename = gf.filename
      # fs.label = gf.label
      # fs.date_uploaded = gf.date_uploaded
      # fs.date_modified = gf.date_modified
      fs.apply_depositor_metadata(depositor)
      fs.save!
      # File
      got_image = "false"
      got_image = "true" if File.exist?("#{ENV['MIGRATION_OBJECTS_PATH']}#{gf.id}")

      # Log imported item
      Osul::Import::ImportedItem.create(fid: fs.id, got_image: got_image, object_type: "FileSet", gw_relation: gf.fid)

      import_current_version(gf, fs) if got_image == "true"
      fs
    end

    def sufia6_content_open_uri(id)
      content_uri = "#{@settings.sufia6_fedora_root_uri}/#{ActiveFedora::Noid.treeify(id)}/content"
      file = open(content_uri, http_basic_authentication: [@settings.sufia6_user, @settings.sufia6_password])
      file
    end

    def import_current_version(gf, fs)
      # Download the current version to disk...
      filename_on_disk = "#{ENV['MIGRATION_OBJECTS_PATH']}#{gf.fid}"
      # Rails.logger.debug "[IMPORT] Downloading #{filename_on_disk}"
      # File.open(filename_on_disk, 'wb') do |file_to_upload|
      #   source_uri = sufia6_content_open_uri(gf.fid)
      #   file_to_upload.write source_uri.read
      # end

      IngestFileJob.perform_now(fs, filename_on_disk, "application/octet-stream", User.find_by(email: gf.depositor))
      CreateDerivativesJob.perform_now(fs, filename_on_disk)

      # ...upload it...
      # File.open(filename_on_disk, 'rb') do |file_to_upload|
      #   Hydra::Works::UploadFileToFileSet.call(fs, file_to_upload)
      # end

      # ...and characterize it.
      # TODO: perform_now or perform_later?
      #       What's the risk of leaving too many files on disk?
      #       Delete filename_on_disk at the end.
      # CharacterizeJob.perform_now(fs, filename_on_disk)
      # CreateDerivativesJob.perform_now(fs, filename_on_disk)
      # IngestFileJob.perform(fs, filename_on_disk, "application/octet-stream", User.first)
    end
  end

  class ImportGenericWork
    def initialize(settings)
      @settings = settings
    end

    def terms
      # removed visibility b/c it's coming from solr :visibility
      [ :date_uploaded, :identifier, :resource_type, :title, :creator, :contributor, :description, :bibliographic_citation,
        :rights, :provenance, :publisher, :date_created, :subject, :language, :based_near, :related_url,
        :work_type, :spatial, :alternative, :temporal, :format, :staff_notes, :source, :part_of, :preservation_level_rationale,
        :preservation_level, :depositor, :handle]
      # :id, :tag,:batch_id, :collection_identifier, :collection_id, :admin_policy_id, :filename
    end

    def complex_terms
      [:materials, :measurements]
    end

    # lookup collections that item should belong to by using the mapping hash of collections exported from ims
    def collection_lookup(old_collection_id)
      h = { "0003ea82-c22a-4faf-b3e1-764d0f3c332f" => "5h73pw06t",
            "ae89efa7-24d2-49dc-b8d5-219fb6003a27" => "1g05fb61q",
            "93739557-325a-464c-b88d-42d818b2a83b" => "q524jn78d",
            "b4f4d3d1-652d-4ddf-aad2-04831b46b455" => "m900nt40f",
            "3db58b0e-a963-4f67-878d-95a18b1f5216" => "47429912h",
            "d8858659-c4bd-4936-a7f8-3d956c4f33c5" => "f1881k89j",
            "1f4046b7-4c2e-416d-b5f7-40960ee6ab83" => "xp68kg24f",
            "2df457d8-f0d6-45ab-a857-3e3769ee8aa3" => "hx11xf263",
            "5994a903-98d0-41ab-9575-f8e34b4023cf" => "bz60cw251",
            "bf42d323-2580-4710-990f-b70bbbca72b8" => "rn301137d",
            "e75d9647-0bfc-41e0-b5e1-8040b1cba83d" => "3r074t92z",
            "95c77baf-0979-4f62-ae86-8d98212fcdc1" => "p5547r37h" }
      h[old_collection_id]
    end

    def from_gf(gf, depositor)
      Rails.logger.debug "Creating GenericWork for  generic_file_id #{gf.fid}.."
      gw = GenericWork.new
      gw.apply_depositor_metadata(depositor)
      gw.id = gf.fid
      gw.unit = gf.unit # "BillyIrelandCartoonLibraryMuseum"
      # loop through each term and call the corresponding method to get the data
      terms.each do |t|
        gw.send((t.to_s + "=").to_sym, gf.send(t))
      end

      gw.save # create gw and persist id so that measurements and materials can be saved
      # Log imported item
      Osul::Import::ImportedItem.create(fid: gf.fid, object_type: "GenericWork")

      # loop through each complex object and call the corresponding methods to get the data
      complex_terms.each do |ct|
        gf.send(ct).to_a.each do |complex_term|
          gw[ct] << create_measurements(complex_term.to_h) if ct == :measurements
          gw[ct] << create_materials(complex_term.to_h) if ct == :materials
        end
      end
      unless gw.collection_id.blank?
        cid = collection_lookup(gw.collection_id)
        collection = Collection.find(cid)
        collection.members << gw
        collection.save
      end
      gw
    end

    def create_measurements(measurement)
      Rails.logger.debug "Creating measurement with id #{measurement[:id]} for  generic_file_id #{measurement[:generic_file_id]}.."
      # First we have to change the key in the hash from generic_file_id to :generic_work_id
      d = measurement.delete(:generic_file_id)
      measurement[:generic_work_id] = d
      new_measurement = Osul::VRA::Measurement.create!(measurement)
      # Log imported item
      Osul::Import::ImportedItem.create(fid: new_measurement.id, object_type: "Measurement", gw_relation: new_measurement.generic_work_id )
      new_measurement
    end

    def create_materials(material)
      Rails.logger.debug "Creating material with id #{material[:id]} for  generic_file_id #{material[:generic_file_id]}.."
      # First we have to change the key in the hash from generic_file_id to :generic_work_id
      d = material.delete(:generic_file_id)
      material[:generic_work_id] = d
      new_material = Osul::VRA::Material.create!(material)
      # Log imported item
      Osul::Import::ImportedItem.create(fid: new_material.id, object_type: "Material", gw_relation: new_material.generic_work_id)
      new_material
    end
  end

  class ImportGenericFile
    attr_reader :settings

    def initialize(settings)
      @settings = settings
    end

    def import(gf)
      depositor = gf.depositor
      # File Set + File
      fs = ImportFileSet.new(settings).from_gf(gf, depositor)

      # Generic Work
      gw = ImportGenericWork.new(settings).from_gf(gf, depositor)
      gw.ordered_members << fs
      gw.save!
      Rails.logger.debug "[IMPORT] Created generic work #{gw.id}"

      # TODO: set generic work thumbnail (shouldn't this happen automatically in create derivatives)
      gw
    end
  end

  class ImportService
    attr_reader :settings
    def initialize(settings)
      @settings = settings
    end

    def request_all_items
      require 'net/http'
      require 'json'

      Osul::Import::Item.delete_all
      Osul::Import::ImportedItem.delete_all

      num_of_items = 36000 # need to change this and get the number dynamically
      limit = 100
      offset = 0
      loop do
        url = "#{@settings.sufia6_root_uri}/osul/export/export_generic_file_items.json?limit=#{limit}&offset=#{offset}"
        uri = URI(url)

        req = Net::HTTP::Get.new(uri)

        response = Net::HTTP.start(
          uri.host, uri.port,
          use_ssl: uri.scheme == 'https',
          verify_mode: OpenSSL::SSL::VERIFY_NONE
        ) do |https|
          https.request(req)
        end

        items = JSON.parse(response.body, object_class: OpenStruct)
        items.each do |gf|
          attributes = gf.to_h
          attributes.delete(:id)
          Osul::Import::Item.create(attributes)
        end

        break if (offset + limit) > num_of_items
        offset += limit
      end
    end

    def import
      Osul::Import::Item.unimported_items.where("unit = 'ByrdPolarResearchCenterArchivalProgram'").limit(20).each do |generic_file|
        Rails.logger.debug "next up -- #{generic_file.fid} "
        import_generic_file(generic_file)
      end
    end

    def import_item(item_id)
      generic_file = Osul::Import::Item.find_by(fid: item_id)
      Rails.logger.debug "next up -- #{generic_file.fid} "
      import_generic_file(generic_file)
    end

    def undo_imported_items
      Osul::Import::ImportedItem.all.each do |item|
        Rails.logger.debug "Removing #{item.fid}...."
        begin
          obj = ActiveFedora::Base.find(item.fid)
        rescue
          Rails.logger.debug "Couldn't find item"
          next
        end
        obj.destroy # This will destroy the associated file_sets but will not eradicate them (but then again we don't need to)
        obj.eradicate
      end
      Osul::Import::ImportedItem.delete_all
    end

    def import_generic_file(generic_file)
      ImportGenericFile.new(@settings).import(generic_file)
    end
  end
end
