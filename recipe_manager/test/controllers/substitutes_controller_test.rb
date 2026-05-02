require "test_helper"

class SubstitutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @substitute = substitutes(:one)
  end

  test "should get index" do
    get substitutes_url
    assert_response :success
  end

  test "should get new" do
    get new_substitute_url
    assert_response :success
  end

  test "should create substitute" do
    assert_difference("Substitute.count") do
      post substitutes_url, params: { substitute: { effect: @substitute.effect, name: @substitute.name, ratio: @substitute.ratio, substitution_id: @substitute.substitution_id } }
    end

    assert_redirected_to substitute_url(Substitute.last)
  end

  test "should show substitute" do
    get substitute_url(@substitute)
    assert_response :success
  end

  test "should get edit" do
    get edit_substitute_url(@substitute)
    assert_response :success
  end

  test "should update substitute" do
    patch substitute_url(@substitute), params: { substitute: { effect: @substitute.effect, name: @substitute.name, ratio: @substitute.ratio, substitution_id: @substitute.substitution_id } }
    assert_redirected_to substitute_url(@substitute)
  end

  test "should destroy substitute" do
    assert_difference("Substitute.count", -1) do
      delete substitute_url(@substitute)
    end

    assert_redirected_to substitutes_url
  end
end
