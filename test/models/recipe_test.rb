require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.create!(chefname: "testchefname", email: "testchef@gmail.com",
                        password: "password", password_confirmation: "password")
    @recipe = @chef.recipes.build(name: "vegetable", description: "test recipe for vegetable")
  end
  
  test "recipe should be valid" do
    assert @recipe.valid?
  end
  
  test "name should be present" do
    @recipe.name = " "
    assert_not @recipe.valid?
  end
  
  test "description should be present" do
    @recipe.description = " "
    assert_not @recipe.valid?
  end

  test "description should not be less than 5 characters long" do
    @recipe.description = "a" * 4
    assert_not @recipe.valid?
  end

  test "description should not be more than 500 characters long" do
    @recipe.description = "a" * 501
    assert_not @recipe.valid?
  end

# @recipe.chef = nil passes, but this does not. This is because the @recipe above already has a chef (which is wrongly configured, because it now doesn't have an id.) Therefore, the need to add further validation to the Recipe model.
  test "chef_id should be present" do
    @recipe.chef_id = nil
    assert_not @recipe.valid?
  end

end