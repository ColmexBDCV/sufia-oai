module Tombstoneable
  extend ActiveSupport::Concern

  included do
    rescue_from ::CanCan::AccessDenied, with: :check_object_status
  end

  private

  def check_object_status
    halt = false

    if action_name == 'show'
      # rubocop:disable Lint/HandleExceptions
      begin
        ActiveFedora::Base.find params[:id]
      rescue Ldp::Gone, ActiveFedora::ObjectNotFoundError => ex
        halt = true
        ex.is_a?(Ldp::Gone) ? render_gone : render_not_found
      rescue
        # Continue with original exception
      end
      # rubocop:enable Lint/HandleExceptions
    end

    authenticate_or_deny_access unless halt
  end

  def render_gone
    render 'errors/410', layout: 'error', status: 410
  end

  def render_not_found
    render 'errors/404', layout: 'error', status: 404
  end
end
