module Nextbbs
  # 2ch Browserでないことを保証する
  class NotNichanBrowserConstraint
    def self.matches?(req)
      # Rails.logger.debug req.env
      !useragent_2ch?(req)
    end

    def self.useragent_2ch?(request)
      ua = request.env["HTTP_USER_AGENT"]
      if ua.present? && ua.include?("JaneStyle")
        true
      else
        false
      end
    end
  end
end
