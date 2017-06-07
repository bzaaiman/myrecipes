require 'test_helper'

class ListChefsTest < ActionDispatch::IntegrationTest

  setup do
    @chef = Chef.create!(chefname: "cheffy", email: "cheffy@gmail.com",
                          password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "cheffy2", email: "cheffy2@gmail.com",
                          password: "password", password_confirmation: "password")
  end

  test "list all chefs" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), text: @chef.chefname.capitalize
    assert_select "a[href=?]", chef_path(@chef2), text: @chef2.chefname.capitalize
  end
  
  test "should delete chef" do
    get chefs_path
    assert_template 'chefs/index'
    assert_difference "Chef.count", -1 do
      delete chef_path(@chef2)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end

end
