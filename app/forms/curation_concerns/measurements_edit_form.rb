module CurationConcerns
  module MeasurementsEditForm
    extend ActiveSupport::Concern

    module ClassMethods
      def build_permitted_params
        permitted = super
        permitted << { :measurements_attributes => [:measurement, :measurement_unit, :measurement_type, :id, :_destroy] }
      end
    end

    included do
      self.terms += [ :measurements_attributes ]
    end

    def measurements_attributes= attributes
      model.measurements_attributes= attributes
    end

    def measurements
      model.measurements
    end
      
  end
end
