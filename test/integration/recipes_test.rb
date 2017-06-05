require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  setup do
    @chef = Chef.create!(chefname: "cheffy", email: "cheffy@gmail.com")
    @recipe = Recipe.create(name: "Sauteed Veggies", description: "Great recipe for suateed recipes!", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "chicken", description: "So-so chicken recipe.")
    @recipe2.save
  end
  
  test "should get index" do
    get recipes_url
    assert_response :success
  end
  
  test "retrieve list of recipes" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end
  
end
