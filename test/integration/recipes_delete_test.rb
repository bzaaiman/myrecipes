require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest

  setup do
    @chef = Chef.create!(chefname: "cheffy", email: "cheffy@gmail.com",
                          password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "Sauteed Veggies", description: "Great recipe for suateed recipes!", chef: @chef)
  end

  test "successfully delete a recipe" do
    sign_in_as(@chef, @chef.password)
    get recipe_path(@recipe)
    assert_template "recipes/show"
    assert_select "a[href=?]", recipe_path(@recipe), text: "Delete this recipe"
    assert_difference "Recipe.count", -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end

end
