require_dependency "nextbbs/application_controller"

module Nextbbs
  class CommentsController < ApplicationController
    before_action :set_comment, only: [:show, :edit, :update, :destroy]

    # GET /comments
    def index
      @topic   = Topic.find(params[:topic_id])
      @comments = Comment.all
    end

    # GET /comments/1
    def show
    end

    # GET /comments/new
    def new
      @topic   = Topic.find(params[:topic_id])
      @comment = Comment.new
    end

    # GET /comments/1/edit
    def edit
    end

    # POST /comments
    def create
      @topic   = Topic.find(params[:topic_id])
      # @comment = Comment.new(comment_params)
      p @topic
      @comment = @topic.comments.new(comment_params)

      if @comment.save
        redirect_to @comment, notice: 'Comment was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /comments/1
    def update
      if @comment.update(comment_params)
        redirect_to @comment, notice: 'Comment was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /comments/1
    def destroy
      @comment.destroy
      redirect_to comments_url, notice: 'Comment was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_comment
        @comment = Comment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def comment_params

        params.require(:comment).permit(:name, :body, :topic_id)
      end
  end
end
