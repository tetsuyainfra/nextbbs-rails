require_dependency "nextbbs/application_controller"
require 'csv'

module Nextbbs
  class ShitarabaController < ApplicationController
    protect_from_forgery except: :bbs

    # /[BOARD]/
    def index
    end

    # /[BOARD]/subject.txt
    def subject
      # @topics = Topic.all
      # render "nextbbs/shitaraba/subject.txt.erb", content_type: 'text/plain; charset=Shift_JIS'
      @topics = Topic.all
      generated_dat = CSV.generate(col_sep: "<>", row_sep: "\n") do | csv |
        @topics.each do |t|
          csv << ["#{t.id}.dat", "#{t.title} (#{t.comments.count})"]
        end
      end

      render plain: generated_dat.encode(Encoding::CP932, invalid: :replace, undef: :replace),
              content_type: 'text/plain; charset=Shift_JIS'
    end

    # /[BOARD]/dat/[:id].dat
    def dat
      @topic = Topic.find(params[:id])
      @comments = @topic.comments

      generated_dat = CSV.generate(col_sep: "<>", row_sep: "\n ") do | csv |
        @comments.each do |c|
          # csv << [c.name, c.email, c.date, c.body, c.id]
          csv << [c.name, nil, I18n.l(c.created_at, format: "%Y/%m/%d(%a) %H:%M:%S.%2N"), c.body, nil]
        end
      end

      render plain: generated_dat.encode(Encoding::CP932, invalid: :replace, undef: :replace),
              content_type: 'text/plain; charset=Shift_JIS'
    end

    # /test/bbs.cgi
    def bbs
      name = params[:FROM] || "ななし"
      email = params[:mail] || ""
      body = params[:MESSAGE]
      @write_result = true
      count = 3
      url = "/nextbbs/shitaraba/"
      @refresh_content = "#{count}; URL=#{url}"
      body = <<~"EOS"
      <html>
      <!-- 2ch_X:#{ @write_result } -->
      <head>
        <title>nextbbs-bbs.cgi</title>
        <meta http-equive="refresh" content="#{@refresh_content}">
      </head>
      <body>
      書き込めました
      </body>
      EOS
      render plain: body.encode(Encoding::CP932, invalid: :replace, undef: :replace),
              content_type: 'text/html; charset=Shift_JIS'
    end

    private

    def bbs_params
      params.permit(:submit, :FROM, :mail, :MESSAGE, :bbs, :key, :time)
    end

  end
end
