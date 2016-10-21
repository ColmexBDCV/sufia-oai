require 'handle'

class HandleService
  def initialize(generic_file)
    @generic_file = generic_file

    @mint_handles = true unless Rails.configuration.x.handle["mint"] == false
    @prefix       = Rails.configuration.x.handle["prefix"]
    @index        = Rails.configuration.x.handle["index"].to_i
    @adminhdl     = Rails.configuration.x.handle["admin_handle"]
    @admpriv      = Rails.configuration.x.handle["admin_priv_key"]
    @admpass      = Rails.configuration.x.handle["admin_passphrase"]
    @url          = Rails.configuration.x.handle["url"]
  end

  def mint
    if minting_disabled?
      Rails.logger.debug "Handle was not created for file #{@generic_file.id} because minting is disabled."
    elsif no_handle?
      Rails.logger.debug "Handle not created. File #{@generic_file.id} does not have a handle property."
    elsif handle_needed?
      create_handle!
      @generic_file.handle
    else
      Rails.logger.debug "Handle not created. File #{@generic_file.id} does not need a handle."
    end
  end

  private

  def minting_disabled?
    !@mint_handles
  end

  def no_handle?
    !@generic_file.respond_to? :handle
  end

  def handle_needed?
    @generic_file.handle.blank? && file_is_visible? && file_has_no_active_imports?
  end

  def create_handle!
    # Create handle string
    handle = "#{@prefix}/#{SecureRandom.uuid}"

    begin
      # Set up an authenticated connection
      conn = Handle::Connection.new(@adminhdl, @index, @admpriv, @admpass)

      # Create an empty record
      record = conn.create_record(handle)

      # add field
      url =  "#{@url}#{@generic_file.id}"
      record.add(:URL, url).index = 2
      record << Handle::Field::HSAdmin.new(@adminhdl)

      # Manipulate permissions
      record.last.perms.public_read = false

      record.save
      @generic_file.handle = [handle]
      @generic_file.save
      Rails.logger.info "The handle #{handle} was successfully created for file #{@generic_file.id}"

    rescue Handle::HandleError => e
      Rails.logger.error "ERROR! A new handle could not be minted for file #{@generic_file.id}. The exception was:"
      Rails.logger.error "#{e.class}: #{e.message}"
    end
  end

  def file_is_visible?
    @generic_file.visibility != Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
  end

  def file_has_no_active_imports?
    if @generic_file.is_a? GenericWork
      Import.with_imported_file(@generic_file).where.not(status: Import.statuses[:final]).empty?
    else
      true
    end
  end
end
