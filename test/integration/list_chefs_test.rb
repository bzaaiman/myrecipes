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
    assert_select "a[href=?]", chef_path(@chef), text: @chef.chefname
    assert_select "a[href=?]", chef_path(@chef2), text: @chef2.chefname
  end

end
