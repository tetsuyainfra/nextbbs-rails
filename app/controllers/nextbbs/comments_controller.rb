require_dependency "nextbbs/application_controller"

module Nextbbs
  class CommentsController < ApplicationController
    before_action :set_comment, only: [:show, :edit, :update, :destroy]

    before_action :_authenticate_with, only: [:index, :edit]

    # GET /comments
    def index
      # @topic = Topic.find(params[:topic_id])
      # @comments = Comment.where(owner: @user)
      # @comments = Comment.where(owner: @user).eager_load(:topic)
      @comments = Comment.where(owner: @user).eager_load(:topic => :board)
    end

    # GET /comments/1
    def show
      if _current_user == @comment.owner || _current_user == @board.owner
        respond_to do |format|
          format.html { render }
          format.json { render }
        end
        return
      end

      respond_to do |format|
        case @board.status.to_sym
        when :deleted
          format.html { head :not_found }
          format.json { head :not_found } # これでいいかな？
        when :unpublished
          # return 403
          format.html { head :not_found }
          format.json { head :not_found } # これでいいかな？
        when :published
          format.html { render }
          format.json { render }
        end
      end
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
      # @comment.destroy
      case @comment.status
      when "published"
        @comment.status = :deleted
      end

      if @comment.save
        redirect_to comments_url, notice: "Comment was successfully destroyed."
      else
        redirect_to comments_url, notice: "Comment had be destroyed already."
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
      @topic = @comment.topic
      @board = @topic.board
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:form_comment).permit(:topic_id, :name, :email, :body)
    end
  end
end
