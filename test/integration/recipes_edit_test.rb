require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest

  setup do
    @chef = Chef.create!(chefname: "cheffy", email: "cheffy@gmail.com",
                          password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "Sauteed Veggies", description: "Great recipe for suateed recipes!", chef: @chef)
  end

  test "should accept valid edited recipe submission" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    name_of_recipe = "Delicious"
    description_of_recipe = "Put some delicious ingredients into a delivious pot and cook for a delicious period until all the deliciousness is done."
    patch recipe_path(@recipe), params: {recipe: {name: name_of_recipe, description: description_of_recipe}}
# showing another way of testing the outcome
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match name_of_recipe, @recipe.name
    assert_match description_of_recipe, @recipe.description
#    follow_redirect!
#    assert_match name_of_recipe.capitalize, response.body
#    assert_match description_of_recipe, response.body
  end

  test "should reject invalid edited recipe submission" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: {recipe: {name: "", description: ""}}
    assert_template 'recipes/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

end
