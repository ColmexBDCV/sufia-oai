module Sufia
  class CollectionPresenter < CurationConcerns::CollectionPresenter
    delegate :resource_type, :based_near, :related_url, to: :solr_document

    # Terms is the list of fields displayed by app/views/collections/_show_descriptions.html.erb
    def self.terms
      [:title, :total_items, :size, :resource_type, :description, :creator,
       :contributor, :keyword, :rights, :publisher, :date_created, :subject,
       :language, :identifier, :based_near, :related_url]
    end

    def terms_with_values
      self.class.terms.select { |t| self[t].present? }
    end

    def [](key)
      case key
      when :size
        size
      when :total_items
        total_items
      else
        solr_document.send key
      end
    end
    
    def display_feature_link?
      user_can_feature_collections? && solr_document.public? && FeaturedCollection.can_create_another? && !featured?
    end

    def display_unfeature_link?
      user_can_feature_collections? && solr_document.public? && featured?
    end
 
    private
      def featured?
        if @featured.nil?
          @featured = FeaturedCollection.where(collection_id: solr_document.id).exists?
        end
        @featured
      end

      def user_can_feature_collections?
        current_ability.can?(:create, FeaturedCollection)
      end
  end
end
