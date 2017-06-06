class ChefsController < ApplicationController
  
  def new
    @chef = Chef.new
  end
  
  def index
    @chefs = Chef.all
  end
  
  def show
    set_chef
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
  
  private
  
    def set_chef
      @chef = Chef.find(params[:id])
    end
    
    def chef_params
      params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
    end
  
end