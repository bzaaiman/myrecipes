class CommentsController < ApplicationController

  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:index, :show] # Remember the require_user method was defined in ApplicationController
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def show
  end
  
  def index
    @comments = Comment.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @comment = Comment.new
    @comment.chef = current_chef
  end
  
  def create
    @comment = Comment.new(comments_params)
  end
  
  def edit
  end
  
  def update
    if @comment.update(comments_params)
      flash[:success] = "Comment succesfully updated."
      redirect_to comment_path(@comment)
    else
      render 'edit'
    end
  end
  
  def destroy
    @comment.destroy
    flash[:success] = "Comment successfuly deleted."
    redirect_to comments_path
  end

  private
  
    def set_comment
      @comment = Comment.find(params[:id])
    end
    
    def comments_params
      params.require(:comment).permit(:description, :chef_id, :recipe_id)
    end
    
    def require_admin_user
      if current_chef != @comment.chef and !current_chef.admin?
        flash[:danger] = "Only Admins can edit or delete comments."
        redirect_to comments_path
      end
    end
    
end
