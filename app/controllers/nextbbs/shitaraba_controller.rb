require_dependency "nextbbs/application_controller"
require 'csv'

module Nextbbs
  class ShitarabaController < ApplicationController

    # /
    def index
    end

    # /subject.txt
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

    # /dat/[:id].dat
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

  end
end
