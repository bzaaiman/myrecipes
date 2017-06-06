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
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end
  
  test "should get recipe show" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name.capitalize, response.body
    assert_match @recipe.description, response.body
    assert_match @recipe.chef.chefname, response.body
    assert_select "a[href=?]", edit_recipe_path(@recipe), text: "Edit this recipe"
    assert_select "a[href=?]", recipe_path(@recipe), text: "Delete this recipe"
    assert_select "a[href=?]", recipes_path, text: "List recipes"
  end
  
  test "should accept valid recipe" do
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = "Delicious"
    description_of_recipe = "Put some delicious ingredients into a delivious pot and cook for a delicious period until all the deliciousness is done."
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: {recipe: {name: name_of_recipe, description: description_of_recipe}}
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end


  test "should reject invalid recipe submission" do
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: {recipe: {name: "", description: ""}}
    end
    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
end
