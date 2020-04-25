require_dependency "nextbbs/application_controller"

module Nextbbs
  class BoardsController < ApplicationController
    before_action :set_board, only: [:show, :edit, :update, :destroy, :control]
    before_action :_authenticate_with, only: [:new, :create, :update, :edit, :destroy, :control]

    # GET /boards
    def index
      @boards = Board.all
    end

    # GET /boards/1
    def show
      @topics = @board.topics
      respond_to do |format|
        case @board.status.to_sym
        when :deleted, :unpublished then
          if _current_user == @board.owner
            format.html { render }
            format.json { render }
          else
            # return 403
            format.html { head :not_found }
            format.json { head :not_found } # これでいいかな？
          end
        when :published then
          format.html { render }
          format.json { render }
        end
      end
    end

    # GET /boards/new
    def new
      @board = Board.new
    end

    # GET /boards/1/edit
    def edit
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
        redirect_to @board, notice: "Board was successfully created."
      else
        logger.debug @board.errors.inspect
        render :new
      end
    end

    # PATCH/PUT /boards/1
    def update
      if @board.update(board_params)
        redirect_to @board, notice: "Board was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /boards/1
    def destroy
      respond_to do |format|
        if @board.destroy
          format.html { redirect_to boards_url, notice: "Board was successfully destroyed." }
          format.json { head :no_content }
        else
          format.html { redirect_to boards_url, notice: "Board was not destroyed. Tell Server Administrator" }
          format.json { head :no_content }
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
      params.require(:board).permit(:title, :description, :name, :status, :owner_id)
    end
  end
end
