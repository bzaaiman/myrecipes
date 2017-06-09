require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  setup do
    @chef = Chef.create!(chefname: "cheffy", email: "cheffy@gmail.com",
                          password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "cheffy2", email: "cheffy2@gmail.com",
                          password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "cheffy2", email: "admin_user@gmail.com",
                          password: "password", password_confirmation: "password", admin: true)
  end
  
  test "edit chef route exists" do
    sign_in_as(@chef, @chef.password)
    get edit_chef_path(@chef)
    assert_response :success
  end

  test "reject invalid edited chef" do
    sign_in_as(@chef, @chef.password)
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'    
    name_of_chef = "bb"
    email_of_chef = "ff"
    patch chef_path, params: {chef: {chefname: name_of_chef, email: email_of_chef}}
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "accept valid edited chef" do
    sign_in_as(@chef, @chef.password)
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'    
    name_of_chef = "foodmeister"
    email_of_chef = "ben@dcisio.com"
    patch chef_path, params: {chef: {chefname: name_of_chef, email: email_of_chef}}
    follow_redirect!
    assert_match name_of_chef, response.body
    assert_not flash.empty?
  end

  test "accept edit by admin user" do
    sign_in_as(@admin_user, @admin_user.password)
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'    
    name_of_chef = "foodmeister3"
    email_of_chef = "ben3@dcisio.com"
    patch chef_path, params: {chef: {chefname: name_of_chef, email: email_of_chef}}
    follow_redirect!
    assert_match @chef.chefname, response.body
    assert_not flash.empty?
  end

  test "redirect attempted edit by non-admin user" do
    sign_in_as(@chef2, @chef2.password)
    original_chefname = @chef.chefname
    name_of_chef = "foodmeister3"
    email_of_chef = "ben3@dcisio.com"
    patch chef_path(@chef), params: {chef: {chefname: name_of_chef, email: email_of_chef}}
    follow_redirect!
    assert_match original_chefname, response.body
    assert_not flash.empty?
  end

end
