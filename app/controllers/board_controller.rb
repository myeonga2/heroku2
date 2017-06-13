class BoardController < ApplicationController
  #before_action :authenticate_user!
  def index
    @boards = Boarddb.all
  end

  def new
    if user_signed_in?
    
    else
      redirect_to '/users/sign_in'
    end
  end

  def create
    board = Boarddb.new
    board.title = params[:title]
    board.contente = params[:content]
    board.password = params[:password]
    board.user_id = current_user.id
    
    if board.save
      redirect_to "/board/index"
    else
      render :text => board.errors.messages[:title].first
    end
  end

  def show
    @board = Boarddb.find_by_id(params[:id])
    
    @comments = Comment.where("boarddb_id LIKE?",params[:id]).reverse
  end

  def edit
    @board = Boarddb.find_by_id(params[:id])
  end

  def update
    board = Boarddb.find_by_id(params[:id])
    board.title = params[:title]
    board.content = params[:content]
    board.save
    
    redirect_to "/board/#{params[:id]}/show"
  end

  def delete
    Boarddb.find_by_id(params[:id]).destroy
    
    redirect_to "/board/index"
  end
  
  def comment_create
    @board_id = params[:board_id]
    @content = params[:content]
    
    comment = Comment.new
    comment.boarddb_id = @board_id
    comment.content = @content
    comment.save
    
    redirect_to "/board/#{@board_id}/show"
  end
end
