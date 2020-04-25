module Nextbbs
  module Extensions
    module Pundit

      class AuthorizationAdapter
        def self.setup
          Nextbbs::ApplicationController.class_eval do
            include ::Pundit
          end unless Nextbbs::ApplicationController.ancestors.include? 'Pundit'
        end

        def initialize(controller)
          @controller = controller
        end
      end # AuthorizationAdapter

    end # module Pundit
  end # module Extensions
end # module Nextbbs