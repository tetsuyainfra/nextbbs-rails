require_dependency "nextbbs/application_controller"

module Nextbbs
  class ShitarabaController < ApplicationController

    # /
    def index
    end

    # /subject.txt
    def subject
      @topics = Topic.all
      render "nextbbs/shitaraba/subject.txt.erb", content_type: 'text/plain; charset=Shift_JIS'
    end

    def dat
      @topic = Topic.find(params[:id])
      @comments = @topic.comments
      render "nextbbs/shitaraba/dat.txt.erb", content_type: 'text/plain; charset=Shift_JIS'
    end

    private
    def change_charset_to_sjis
      # headers["Content-Type"] = 'text/plain; charset=Shift_JIS'
      # response.body           = response.body.encode(Encoding::SHIFT_JIS)
      render "nextbbs/shitaraba/subject.txt.erb", content_type: 'text/plain; charset=Shift_JIS'
    end

  end
end
