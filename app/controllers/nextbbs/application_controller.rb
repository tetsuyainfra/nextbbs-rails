module Nextbbs
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    helper_method :_current_user

    def _current_user
      instance_eval(&Nextbbs.config.current_user_method)
    end

    def _authenticate_with
      instance_eval(&Nextbbs.config.authenticate_with)
    end

    def _authorize!
      instance_eval(&Nextbbs.config.authorize_with)
    end

    def remote_ip
      request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
    end

    ##################################################
    # エラーハンドリング
    ##################################################
    if !Rails.env.development?
      rescue_from Exception, with: :render_500
      rescue_from ActiveRecord::RecordNotFound, with: :render_404
      rescue_from ActionController::RoutingError, with: :render_404
    end

    def routing_error
      raise ActionController::RoutingError.new(params[:path])
    end

    def render_404(e = nil)
      logger.info "Rendering 404 with exception: #{e.message}" if e

      if request.xhr?
        render json: { error: "404 error" }, status: 404
      else
        format = params[:format] == :json ? :json : :html
        render file: Rails.root.join("public/404.html"), status: 404, layout: false, content_type: "text/html"
      end
    end

    def render_500(e = nil)
      logger.info "Rendering 500 with exception: #{e.message}" if e

      if request.xhr?
        render json: { error: "500 error" }, status: 500
      else
        format = params[:format] == :json ? :json : :html
        render file: Rails.root.join("public/500.html"), status: 500, layout: false, content_type: "text/html"
      end
    end
  end
end
