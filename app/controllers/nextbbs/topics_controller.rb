require_dependency "nextbbs/application_controller"
# require_dependency "nextbbs/concerns/ajax_helper"

module Nextbbs
  class TopicsController < ApplicationController
    before_action :set_topics, only: [:index]
    before_action :set_topic, only: [:show, :edit, :update, :destroy]
    before_action :set_board, only: [:new, :create, :destroy]

    before_action :_authenticate_with, only: [:update, :edit, :destroy, :control]

    # GET /topics
    def index
      render "nextbbs/boards/show"
    end

    # GET /topics/1
    def show
      @comments = @topic.comments.sorted
      @new_comment = Form::Comment.new(topic: @topic)
    end

    # GET /topics/new
    def new
      @new_topic = Form::Topic.new(board: @board)
      @new_topic.comments = [Form::Comment.new]
    end

    # GET /topics/1/edit
    def edit
      @form = Form::Topic.find(params[:id])
    end

    # POST /topics
    def create
      # params[:board_id] == @board.id チェックする？
      @new_topic = Form::Topic.new(topic_params)
      @new_topic.board = @board
      @new_topic.status = Topic.statuses[:published]
      @new_topic.comments.each { |c|
        c.status = Comment.statuses[:published]
        c.ip = remote_ip
      }

      # @topic = Topic.new(topic_params)
      logger.debug @new_topic.inspect

      if @new_topic.save
        # redirect_to @topic, notice: 'Topic was successfully created.'
        respond_to do |format|
          format.js { render js: "window.location.replace('#{board_topics_url(@board)}');" }
          format.any { redirect_to board_topics_url(@board) }
        end
      else
        respond_to do |format|
          format.js { render js: "window.location.replace('#{root_path}');" }
          format.any { redirect_to root_path }
        end
      end
    end

    # PATCH/PUT /topics/1
    def update
      if @topic.update(topic_params)
        redirect_to board_topic_path(@board, @topic), notice: "Topic was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /topics/1(.:format)
    def destroy
      # format.html { redirect_to board_topics_path(@board), notice: "Topic was successfully Deleted." }
      # format.js   { render js: "window.location.replace('#{board_topics_url(@board)}');" }
      # format.js { render js: "window.location.replace('#{control_board_url(@board)}');" }
      @board.topics.find(@topic.id)

      respond_to do |format|
        if @topic.destroy
          format.html { redirect_to boards_topics_path(@board), notice: "Topic was successfully destroyed." }
          format.json { head :no_content }
        else
          format.html { redirect_to boards_topics_path(@board), notice: "Topic was not destroyed. Tell Server Administrator" }
          format.json { head :no_content }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:board_id])
    end

    def set_topics
      @board = Board.find(params[:board_id])
      @topics = @board.topics
    end

    def set_topic
      @board = Board.find(params[:board_id])
      @topic = @board.topics.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def topic_params
      # TODO: 下の形式に書き換える
      params
        .require(:form_topic)
        .permit(:board_id, :title,
                comments_attributes: [:name, :email, :body])

      # params
      #   .require(:form_topic)
      #   .permit(
      #     Form::Topic::REGISTRABLE_ATTRIBUTES +
      #     [comments_attributes: Form::Comment::REGISTRABLE_ATTRIBUTES]
      #   )
    end
  end
end
