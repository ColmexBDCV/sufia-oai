module API
  module V1
    class PropertiesController < CatalogController
      include API::ControllerBehavior

      before_action :configure_property, only: :show
      skip_before_action :enforce_show_permissions

      def index
        @properties = Property.all
      end

      def show
        @property = Property.find params[:id]
      end

      private

      def configure_property
        Property.search_builder = search_builder
        Property.repository = repository
      end
    end
  end
end
