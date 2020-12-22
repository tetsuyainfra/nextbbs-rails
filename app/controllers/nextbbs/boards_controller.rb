require_dependency "nextbbs/application_controller"

module Nextbbs
  class BoardsController < ApplicationController
    before_action :set_board, only: [:show, :edit, :update, :destroy, :control]
    before_action :_authenticate_with, only: [:new, :create, :update, :edit, :destroy, :control, :yours]
    before_action :validate_user, only: [:control, :edit, :update, :destroy]

    # GET /boards
    def index
      # @boards = Board.all
      @boards = Board.published
    end

    # GET /boards/1
    def show
      @topics = @board.topics
      respond_to do |format|
        case @board.status.to_sym
        when :removed
          format.html { head :not_found }
          format.json { head :not_found } # これでいいかな？
        when :unpublished
          if _current_user == @board.owner
            format.html { render }
            format.json { render }
          else
            # return 403
            format.html { head :not_found }
            format.json { head :not_found } # これでいいかな？
          end
        when :published
          format.html { render }
          format.json { render }
        else
          raise NotImplementedError
        end
      end
    end

    # GET /boards/yours
    def yours
      # TODO: Board.find でUser.idを絞ったほうが良いかもね
      @boards = _current_user.nextbbs_boards
    end

    # GET /boards/new
    def new
      @board = Board.new
    end

    # GET /boards/1/edit
    def edit
      @topics = @board.topics
    end

    # GET /boards/1/control
    def control
      @topics = @board.topics
    end

    # POST /boards
    def create
      @board = Board.new(board_params)
      @board.owner = _current_user
      if @board.save
        respond_to do |format|
          format.html { redirect_to yours_boards_path, notice: t(".create_success") }
          format.json { head :no_content }
        end
      else
        logger.debug @board.errors.inspect
        render :new
      end
    end

    # PATCH/PUT /boards/1
    def update
      # Ownerチェック
      if @board.update(board_params)
        redirect_to @board, notice: t(".update_success")
      else
        render :edit
      end
    end

    # DELETE /boards/1
    def destroy
      logger.debug destroy_board_params
      unless destroy_board_params[:destroy_seed] && destroy_board_params[:destroy_seed] == @board.hash_token
        flash[alert] = "hash_tokenが違います。"
        redirect_to edit_board_path(@board)
      else
        logger.debug "掲示板を削除します"
        respond_to do |format|
          if @board.destroy
            format.html { redirect_to yours_boards_url, notice: t(".destroy_success") }
            format.js { render ajax_redirect_to(yours_boards_url) }
            format.json { head :no_content }
          else
            format.html { redirect_to boards_url, notice: t(".destroy_failed") }
            format.js { render ajax_redirect_to(boards_url) }
            format.json { head :no_content }
          end
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def board_params
      # params.require(:form_board).permit(:title, :description, :name, :status)
      params.require(:board).permit(:title, :description, :name, :status)
    end

    def destroy_board_params
      params.require(:board).permit(:destroy_seed)
    end

    def validate_user
      if @board.owner != _current_user
        redirect_to board_path(@board), alert: t(".validate_failed")
      end
    end
  end
end
