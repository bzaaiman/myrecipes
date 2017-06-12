class ChefsController < ApplicationController
  
  before_action :set_chef, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def new
    @chef = Chef.new
  end
  
  def index
    @chefs = Chef.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    @chefs_recipes = @chef.recipes.paginate(page: params[:page], per_page: 5)
  end
  
  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      session[:chef_id] = @chef.id
      cookies.signed[:chef_id] = @chef.id # It is necessary to set a signed cookie to work with ActionCable. # Also necessary to to when a new session is created (see sessions controller.)
      flash[:success] = "Welcome, #{@chef.chefname} to MyRecipes!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @chef.update(chef_params)
      flash[:success] = "Chef updated successfully"
      redirect_to chef_path(@chef)
    else 
      render 'edit'
    end  
  end

  def destroy
    if !@chef.admin?
      @chef.destroy
      flash[:danger] = "Chef and all associated recipes deleted"
      redirect_to chefs_path
    else
      flash[:danger] = "Admin may not delete itself"
      redirect_to chefs_path
    end
  end
  
  private
  
    def set_chef
      @chef = Chef.find(params[:id])
    end
    
    def chef_params
      params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
    end
    
    def require_same_user
      if current_chef != @chef and !current_chef.admin?
        flash[:danger] = "You can only edit your own chef"
        redirect_to chefs_path
      end
    end
  
    def require_admin
      if logged_in? && !current_chef.admin?
        flash[:danger] = "Only admin user can perform that action"
        redirect_to root_path
      end
    end
end