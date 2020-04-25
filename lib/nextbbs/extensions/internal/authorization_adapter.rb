module Nextbbs
  module Extensions

    module Internal

      class AuthorizationAdapter
        def self.setup
        end

        def initialize(controller)
          @controller = controller
        end

      end

    end # module Internal
  end # module Extensions
end # module Nextbbs