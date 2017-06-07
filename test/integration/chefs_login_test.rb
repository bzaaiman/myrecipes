require 'test_helper'

class ChefsLoginTest < ActionDispatch::IntegrationTest

  setup do
    @chef = Chef.create!(chefname: "validchefname", email: "chef@chef.com", password: "password")
  end

  test "invalid login credentials are rejected" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: " ", password: " "} }
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    get root_path # this is to check whether the flash message carried over from this previous rendering to a following on without firing (i.e. the flash.now didn't occur). We are therefore renderijng another page, and checking again.
    assert flash.empty?
  end
  
  test "valid login credentials are accepted and start session" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: @chef.email, password: @chef.password} }
    assert_redirected_to @chef # shorthand for chef_path(@chef)
    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", edit_chef_path(@chef)
    assert_select "a[href=?]", chef_path(@chef)
  end

end
