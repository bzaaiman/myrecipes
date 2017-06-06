require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest

  setup do
    @chef = Chef.create!(chefname: "cheffy", email: "cheffy@gmail.com",
                          password: "password", password_confirmation: "password")
    @recipe1 = Recipe.create!(name: "Test Recipe 1", description: "Test recipe description 1", chef: @chef)
# an alternative way of doing the same thing
    @recipe2 = @chef.recipes.build(name: "Test Recipe 2", description: "Test recipe description 2")
    @recipe2.save
  end
  
  test "show chef route exists" do
    get chef_path(@chef)
    assert_response :success
  end

  test "show chef template works" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe1), text: @recipe1.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

end
