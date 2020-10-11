module Nextbbs
  module AjaxHelper
    extend ActiveSupport::Concern

    module ClassMethods
      def ajax_redirect_to(redirect_uri)
        # TODO: 重複を消す
        # { "window.location.replace('#{redirect_uri}');" }
        { js: "window.location.replace('#{redirect_uri}');" }
      end
    end
  end
end
