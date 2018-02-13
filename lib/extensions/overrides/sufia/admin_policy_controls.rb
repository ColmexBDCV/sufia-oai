module Overrides
  module Sufia
    module AdminPolicyControls
      extend ActiveSupport::Concern

      include ::Hydra::PolicyAwareAccessControlsEnforcement
      include ::HasLogger
    end
  end
end
