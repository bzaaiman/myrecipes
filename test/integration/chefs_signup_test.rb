require 'test_helper'

class ChefsSignupTest < ActionDispatch::IntegrationTest

  test "find correct signup route" do
    get signup_path
    assert_response :success
  end

  test "reject an invalid signup" do
    get signup_path
    assert_template 'chefs/new'
    name_of_chef = "bb"
    email_of_chef = "ff"
    password_of_chef = "pp"
    password_confirmation_of_chef = "cc"
    assert_no_difference 'Chef.count' do
      post chefs_path, params: {chef: {chefname: name_of_chef, email: email_of_chef, password: password_of_chef, password_confirmation: password_confirmation_of_chef}}
    end
    assert_template 'chefs/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "accept a valid signup" do
    get signup_path
    assert_template 'chefs/new'
    name_of_chef = "foodmeister"
    email_of_chef = "ben@dcisio.com"
    password_of_chef = "password"
    password_confirmation_of_chef = "password"
    assert_difference 'Chef.count', 1 do
      post chefs_path, params: {chef: {chefname: name_of_chef, email: email_of_chef, password: password_of_chef, password_confirmation: password_confirmation_of_chef}}
    end
    follow_redirect!
    assert_match name_of_chef, response.body
    assert_not flash.empty?
  end

end
