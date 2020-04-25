
module Nextbbs
  module AjaxHelper
    extend ActiveSupport::Concern

    module ClassMethods
      def ajax_redirect_to(redirect_uri)
        { "window.location.replace('#{redirect_uri}');" }
      end
    end
  end
end
