module Sufia
  class WorkShowPresenter < ::CurationConcerns::WorkShowPresenter
    # delegate fields from Sufia::Works::Metadata to solr_document
    delegate :abstract, :based_near, :related_url, :depositor, :identifier, :archival_unit, :resource_type,
             :keyword, :itemtype, :alternative, :format, :handle, :unit, :collection_name,
             :sub_collection, :preservation_level, :preservation_level_rationale,
             :provenance, :spatial, :staff_notes, :temporal, :work_type, :material,
             :material_type, :measurement, :measurement_unit, :measurement_type,
             :bibliographic_citation, :collection_identifier, :audience, :rights_statements, :orcid, :cvu,
             to: :solr_document

    def editor?
      current_ability.can?(:edit, solr_document)
    end

    def destroyer?
      current_ability.can?(:destroy, solr_document)
    end

    def tweeter
      user = ::User.find_by_user_key(depositor)
      if user.try(:twitter_handle).present?
        "@#{user.twitter_handle}"
      else
        I18n.translate('sufia.product_twitter_handle')
      end
    end

    def display_feature_link?
      user_can_feature_works? && solr_document.public? && FeaturedWork.can_create_another? && !featured?
    end

    def display_unfeature_link?
      user_can_feature_works? && solr_document.public? && featured?
    end

    def stats_path
      Sufia::Engine.routes.url_helpers.stats_work_path(self)
    end

    def authorized_member_presenters(action = :read, type = :member)
      instance_variable_get("@#{action}_authorized_#{type}_presenters") || authorize_member_presenters(action, type)
    end

    private

    def featured?
      if @featured.nil?
        @featured = FeaturedWork.where(work_id: solr_document.id).exists?
      end
      @featured
    end

    def user_can_feature_works?
      current_ability.can?(:create, FeaturedWork)
    end

    def authorize_member_presenters(action, type)
      presenters = []
      send("#{type}_presenters").each do |member|
        presenters << member if @current_ability.can?(action, member.id)
      end
      instance_variable_set("@#{action}_authorized_#{type}_presenters", presenters)
    end
  end
end
