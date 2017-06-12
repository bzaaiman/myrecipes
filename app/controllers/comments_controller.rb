class CommentsController < ApplicationController

#  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:index, :show] # Remember the require_user method was defined in ApplicationController
#  before_action :require_same_user, only: [:edit, :update, :destroy]
  
=begin
  def show
  end
  
  def index
    @comments = Comment.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @comment = Comment.new
    @comment.chef = current_chef
  end
  
=end
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comments_params)
    @comment.chef = current_chef
    if @comment.save
      ActionCable.server.broadcast "comments", render(partial: "comments/comment", object: @comment) # I.e. as soon as the change is saved, tell the actioncable server to broadcast the change on the "comments" channel, finally aslo saying what should be rendered over the channel.
#      flash[:success] = "Comment saved" # We don't want this because the message will be sent in real-time and we don't want to redirect to a new page. Aslo, a flash message is only displayed on the next page, which doesn't happen here.
#      redirect_to recipe_path(@recipe)
    else
      flash[:danger] = "Comment was not created"
      redirect_back(fallback_location: root_path) #     This goes back to the previous page, but again through the controller, this correctly being initiated with a correct @comments object
#      render 'recipes/show' # this would not work here because if you are rendering, you are simply rendering the same page again. But because you did not do this through a redirect, it did not pass through the recipes controller, where it would have picked up the @comments object.
#      redirect_to :back  # redirect_to :back has been deprecated in Rails 5
    end
  end
  
=begin  
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
=end
  private
  
    def set_comment
      @comment = Comment.find(params[:id])
    end
    
    def comments_params
      params.require(:comment).permit(:description)
    end
    
end
