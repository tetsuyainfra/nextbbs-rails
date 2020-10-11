require_dependency "nextbbs/application_controller"
require 'csv'

module Nextbbs
  class NichanController < ApplicationController
    protect_from_forgery except: :bbs_cgi

    # # /boards/
    # def index
    #   if useragent_2ch?
    #     body = render_to_string

    #     render plain: body.encode(Encoding::CP932, invalid: :replace, undef: :replace),
    #           content_type: 'text/html; charset=Shift_JIS'
    #   end
    # end

    # /boards/:id/SETTING.TXT
    def setting
      @board  = Board.find(params[:board_id])
      body = <<~"EOS"
      BBS_TITLE=#{@board.title}
      EOS
      render plain: body.encode(Encoding::CP932, invalid: :replace, undef: :replace),
              content_type: 'text/plain; charset=Shift_JIS'
    end

    # /boards/:id/subject.txt
    def subject
      @board  = Board.find(params[:board_id])
      @topics = @board.topics

      generated_dat = CSV.generate(col_sep: "<>", row_sep: "\n", quote_char: '') do | csv |
        @topics.each do |t|
          # TODO: escapeは？
          csv << ["#{t.id}.dat", "#{t.title} (#{t.comments.count})"]
        end
      end

      render plain: generated_dat.encode(Encoding::CP932, invalid: :replace, undef: :replace),
              content_type: 'text/plain; charset=Shift_JIS'
    end

    # /boards/:id/dat/:topic_id.dat
    def dat
      # puts "params: ", params
      @board  = Board.find(params[:board_id])
      @topic  = @board.topics.find(params[:topic_id])
      @comments = @topic.comments

      generated_dat = CSV.generate(col_sep: "<>", row_sep: "\n ", quote_char: '') do | csv |
        @comments.each do |c|
          # csv << [c.name, c.email, c.date, c.body, c.id]
          csv << [
            c.name,
            nil,
            I18n.l(c.created_at, format: "%Y/%m/%d(%a) %H:%M:%S.%2N"),
            ApplicationController.helpers.newline2br(c.body),
            nil
          ]
        end
      end

      render plain: generated_dat.encode(Encoding::CP932, invalid: :replace, undef: :replace),
              content_type: 'text/plain; charset=Shift_JIS'
    end

    # /boards/test/read.cgi/:board_id/:topic_id/
    def read_cgi
      # puts "params: ", params
      @board = Board.find(params[:board_id])
      @topic = @board.topics.find(params[:topic_id])
      @comments = @topic.comments

      @new_comment = Form::Comment.new(topic: @topic)
      render 'nextbbs/topics/show'
    end

    # /boards/test/bbs.cgi
    def bbs_cgi
      @board = Board.find(params[:bbs])
      @topic = @board.topics.find(params[:key])

      name = params[:FROM] || "ななし"
      email = params[:mail] || ""
      body = params[:MESSAGE]

      @write_result = true
      @time_count = 3
      @url = File.join("#{boards_path}", "/test/read.cgi/#{@board.id}/#{@topic.id}/")

      body = <<~"EOS"
      <html>
      <!-- 2ch_X:#{ @write_result } -->
      <head>
        <title>nextbbs-bbs.cgi</title>
        <meta http-equive="refresh" content="#{@time_count}; URL=#{@url}">
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

    def useragent_2ch?
      ua = request.env['HTTP_USER_AGENT']
      if ua.include? "JaneStyle"
        true
      else
        false
      end
    end

  end
end
