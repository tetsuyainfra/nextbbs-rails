require_dependency "nextbbs/application_controller"

module Nextbbs
  class CommentsController < ApplicationController
    before_action :set_comment, only: [:show, :edit, :update, :destroy]

    # GET /comments
    def index
      @topic = Topic.find(params[:topic_id])
      @comments = Comment.all
    end

    # GET /comments/1
    def show
    end

    # GET /comments/1/edit
    def edit
    end

    # # GET /comments/new
    # def new
    #   @topic   = Topic.find(params[:topic_id])
    #   @comment = Comment.new
    # end

    # POST /comments
    def create
      logger.debug "params->topic_id #{comment_params[:topic_id]}"
      unless comment_params[:topic_id]
        redirect_to root_url
      else
        # TODO: ユーザー認証を入れるならここで
        @topic = Topic.find(comment_params[:topic_id])
        @comment = @topic.comments.new(comment_params)

        # TODO: 板情報を見てstatusを変更する
        @comment.status = Comment.statuses[:published]
        @comment.ip = remote_ip

        if @comment.save
          # redirect_to @comment, notice: 'Comment was successfully created.'
          redirect_to [@topic.board, @topic], notice: "Comment was successfully created."
        else
          redirect_to root_url
        end
      end
    end

    # PATCH/PUT /comments/1
    def update
      if @comment.update(comment_params)
        redirect_to @topic, notice: "Comment was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /comments/1
    def destroy
      @comment.destroy
      redirect_to comments_url, notice: "Comment was successfully destroyed."
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:form_comment).permit(:topic_id, :name, :email, :body)
    end
  end
end
