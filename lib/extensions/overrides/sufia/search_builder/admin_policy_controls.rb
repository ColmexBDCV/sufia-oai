module Overrides
  module Sufia
    module SearchBuilder
      module AdminPolicyControls
        include Hydra::PolicyAwareAccessControlsEnforcement

        def logger
          Rails.logger
        end
      end
    end
  end
end
