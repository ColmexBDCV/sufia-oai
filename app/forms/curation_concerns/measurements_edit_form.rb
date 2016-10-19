module CurationConcerns
  module MeasurementsEditForm
    extend ActiveSupport::Concern

    module ClassMethods
      def build_permitted_params
        permitted = super
        permitted << { measurements_attributes: [:measurement, :measurement_unit, :measurement_type, :id, :_destroy] }
      end
    end

    included do
      delegate :measurements, :measurements_attributes=, to: :model
      self.terms << :measurements_attributes
    end
  end
end
