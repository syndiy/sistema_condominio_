require "test_helper"

class UserUnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_unit = user_units(:one)
  end

  test "should get index" do
    get user_units_url
    assert_response :success
  end

  test "should get new" do
    get new_user_unit_url
    assert_response :success
  end

  test "should create user_unit" do
    assert_difference("UserUnit.count") do
      post user_units_url, params: { user_unit: {} }
    end

    assert_redirected_to user_unit_url(UserUnit.last)
  end

  test "should show user_unit" do
    get user_unit_url(@user_unit)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_unit_url(@user_unit)
    assert_response :success
  end

  test "should update user_unit" do
    patch user_unit_url(@user_unit), params: { user_unit: {} }
    assert_redirected_to user_unit_url(@user_unit)
  end

  test "should destroy user_unit" do
    assert_difference("UserUnit.count", -1) do
      delete user_unit_url(@user_unit)
    end

    assert_redirected_to user_units_url
  end
end
