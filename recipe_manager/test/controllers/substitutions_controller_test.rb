require "test_helper"

class SubstitutionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @substitution = substitutions(:one)
  end

  test "should get index" do
    get substitutions_url
    assert_response :success
  end

  test "should get new" do
    get new_substitution_url
    assert_response :success
  end

  test "should create substitution" do
    assert_difference("Substitution.count") do
      post substitutions_url, params: { substitution: { ingredient: @substitution.ingredient, recipe_id: @substitution.recipe_id } }
    end

    assert_redirected_to substitution_url(Substitution.last)
  end

  test "should show substitution" do
    get substitution_url(@substitution)
    assert_response :success
  end

  test "should get edit" do
    get edit_substitution_url(@substitution)
    assert_response :success
  end

  test "should update substitution" do
    patch substitution_url(@substitution), params: { substitution: { ingredient: @substitution.ingredient, recipe_id: @substitution.recipe_id } }
    assert_redirected_to substitution_url(@substitution)
  end

  test "should destroy substitution" do
    assert_difference("Substitution.count", -1) do
      delete substitution_url(@substitution)
    end

    assert_redirected_to substitutions_url
  end
end
