class ChefsController < ApplicationController
  
  def new
    @chef = Chef.new
  end
  
  def index
    @chefs = Chef.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    set_chef
    @chefs_recipes = @chef.recipes.paginate(page: params[:page], per_page: 5)
  end
  
  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      flash[:success] = "Welcome, #{@chef.chefname} to MyRecipes!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end

  def edit
    set_chef
  end

  def update
    set_chef
    if @chef.update(chef_params)
      flash[:success] = "Chef updated successfully"
      redirect_to chef_path(@chef)
    else 
      render 'edit'
    end  
  end
  
  private
  
    def set_chef
      @chef = Chef.find(params[:id])
    end
    
    def chef_params
      params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
    end
  
end