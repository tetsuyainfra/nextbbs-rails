require_dependency "nextbbs/application_controller"

module Nextbbs
  class TopicsController < ApplicationController
    before_action :set_topic, only: [:show, :edit, :update, :destroy]

    # GET /topics
    def index
      @topics = Topic.all
      @topic = Topic.new
    end

    # GET /topics/1
    def show
      @comments = @topic.comments
      @new_comment = Form::Comment.new(topic: @topic)
    end

    # GET /topics/new
    def new
      @form = Form::Topic.new
    end

    # GET /topics/1/edit
    def edit
      @form = Form::Topic.find(params[:id])
    end

    # POST /topics
    def create
      @topic = Topic.new(topic_params)

      if @topic.save
        # redirect_to @topic, notice: 'Topic was successfully created.'
        redirect_to topics_url
      else
        render :new
      end
    end

    # PATCH/PUT /topics/1
    def update
      logger.debug topic_params
      if @topic.update(topic_params)
        redirect_to @topic, notice: 'Topic was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /topics/1
    def destroy
      @topic.destroy
      redirect_to topics_url, notice: 'Topic was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_topic
        @topic = Topic.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def topic_params
        # params
        #   .require(:topic_form)
        #   .permit(:title)
        params
          .require(:form_topic)
          .permit(
            Form::Topic::REGISTRABLE_ATTRIBUTES +
            [comments_attributes: Form::Comment::REGISTRABLE_ATTRIBUTES]
          )
      end
  end
end
