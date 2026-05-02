require "test_helper"

class StepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @step = steps(:one)
  end

  test "should get index" do
    get steps_url
    assert_response :success
  end

  test "should get new" do
    get new_step_url
    assert_response :success
  end

  test "should create step" do
    assert_difference("Step.count") do
      post steps_url, params: { step: { action: @step.action, heat_level: @step.heat_level, notes: @step.notes, optional_data: @step.optional_data, order: @step.order, recipe_id: @step.recipe_id, risk_points: @step.risk_points, targets: @step.targets, temperature_amount: @step.temperature_amount, temperature_description: @step.temperature_description, temperature_unit: @step.temperature_unit, time_amount: @step.time_amount, time_description: @step.time_description, time_per_side: @step.time_per_side, time_unit: @step.time_unit, title: @step.title } }
    end

    assert_redirected_to recipe_url(Step.last.recipe)
  end

  test "should show step" do
    get step_url(@step)
    assert_response :success
  end

  test "should get edit" do
    get edit_step_url(@step)
    assert_response :success
  end

  test "should update step" do
    patch step_url(@step), params: { step: { action: @step.action, heat_level: @step.heat_level, notes: @step.notes, optional_data: @step.optional_data, order: @step.order, recipe_id: @step.recipe_id, risk_points: @step.risk_points, targets: @step.targets, temperature_amount: @step.temperature_amount, temperature_description: @step.temperature_description, temperature_unit: @step.temperature_unit, time_amount: @step.time_amount, time_description: @step.time_description, time_per_side: @step.time_per_side, time_unit: @step.time_unit, title: @step.title } }
    assert_redirected_to recipe_url(@step.recipe)
  end

  test "should destroy step" do
    assert_difference("Step.count", -1) do
      delete step_url(@step)
    end

    assert_redirected_to recipe_url(@step.recipe)
  end
end
