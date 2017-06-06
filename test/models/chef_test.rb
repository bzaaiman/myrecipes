require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.new(chefname: "Bob the Chef", email: "bob@chef.com",
                      password: "password", password_confirmation: "password")
  end
  
  test "chef should be valid" do
    assert @chef.valid?
  end
  
  test "chefname should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end
  
  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "chefname should not be shorter than 5" do
    @chef.chefname = "a" * 4
    assert_not @chef.valid?
  end

  test "chefname should not be longer than 30" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should not be shorter than 6" do
    @chef.email = "a" * 5
    assert_not @chef.valid?
  end

  test "email should not be longer than 255" do
    @chef.email = "a" * 256
    assert_not @chef.valid?
  end

  test "should accept valid email addresses" do
    valid_emails = %w[ben@dcisio.com ben.xaa@gmail.com m+foo@bar.co booboo@far.co.za]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid"
    end
  end

  test "should reject invalid email addresses" do
    invalid_emails = %w[@dcisio.com ben ben.xaa ben@ foor@bar,com hhhhhh@bbb+jdjd.com]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
    end
  end

  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email should be lowercase before hitting db" do
    mixed_email = "BenZ@Gmail.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test "chef password must be present" do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end

  test "password should be at least 5 characters" do
    @chef.password = @chef.password_confirmation = "a" * 4
    assert_not @chef.valid?
  end

end