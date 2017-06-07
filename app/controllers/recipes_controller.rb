class RecipesController < ApplicationController
  
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 5)
  end
  
  def show
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = Chef.first #this a temporary workaround while we don't manually assign chefs. Especially ugly since this is sensitive to scope chages in the model.
    if @recipe.save
      flash[:success] = "Recipe was saved succesfully"
      redirect_to recipe_path(@recipe)
    else
      render 'recipes/new'
    end
  end
  
  def edit
  end
  
  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Recipe was updated succesfully"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end
  
  def destroy
    @recipe.destroy
    flash[:danger] = "Recipe was deleted succesfully"
    redirect_to recipes_path
  end

  private
  
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
  
    def recipe_params
      params.require(:recipe).permit(:name, :description)
    end

end