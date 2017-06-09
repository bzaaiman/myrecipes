class IngredientsController < ApplicationController

  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:index, :show] # Remember the require_user method was defined in ApplicationController
  before_action :require_admin_user, only: [:edit, :update, :destroy]
  
  def show
    @ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 5)
  end
  
  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @ingredient = Ingredient.new
  end
  
  def create
    @ingredient = Ingredient.new(ingredients_params)
    if @ingredient.save
      flash[:success] = "New ingredient successfully saved."
      redirect_to @ingredient
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @ingredient.update(ingredients_params)
      flash[:success] = "Ingredient succesfully updated."
      redirect_to ingredient_path(@ingredient)
    else
      render 'edit'
    end
  end
  
#  def destroy
#    @ingredient.destroy
#    flash[:success] = "Ingredient successfuly deleted."
#    redirect_to ingredients_path
#  end

private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end
  
  def ingredients_params
    params.require(:ingredient).permit(:name, :recipe_ingredients)
  end
  
  def require_admin_user
    if !current_chef.admin?
      flash[:danger] = "Only Admins can edit or delete ingredients."
      redirect_to ingredients_path
    end
  end

end