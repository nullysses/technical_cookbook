require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe = recipes(:one)
  end

  test "should get index" do
    get recipes_url
    assert_response :success
  end

  test "should get new" do
    get new_recipe_url
    assert_response :success
  end

  test "should create recipe" do
    assert_difference("Recipe.count") do
      post recipes_url, params: { recipe: { diet: @recipe.diet, equipment: @recipe.equipment, language: @recipe.language, nutrition_notes: @recipe.nutrition_notes, servings_count: @recipe.servings_count, servings_unit: @recipe.servings_unit, source_created_from: @recipe.source_created_from, source_notes: @recipe.source_notes, tags: @recipe.tags, title: "Created Recipe!", version: @recipe.version, yield_amount: @recipe.yield_amount, yield_description: @recipe.yield_description, yield_unit: @recipe.yield_unit } }
    end

    assert_redirected_to recipe_url(Recipe.last)
    assert_equal "created-recipe", Recipe.last.stable_id
    assert_equal "/recipes/created-recipe", URI.parse(response.location).path
  end

  test "should show recipe" do
    get recipe_url(@recipe)
    assert_response :success
    assert_equal "/recipes/#{@recipe.stable_id}", recipe_path(@recipe)
  end

  test "should get edit" do
    get edit_recipe_url(@recipe)
    assert_response :success
    assert_equal "/recipes/#{@recipe.stable_id}/edit", edit_recipe_path(@recipe)
  end

  test "should update recipe" do
    patch recipe_url(@recipe), params: { recipe: { diet: @recipe.diet, equipment: @recipe.equipment, language: @recipe.language, nutrition_notes: @recipe.nutrition_notes, servings_count: @recipe.servings_count, servings_unit: @recipe.servings_unit, source_created_from: @recipe.source_created_from, source_notes: @recipe.source_notes, tags: @recipe.tags, title: @recipe.title, version: @recipe.version, yield_amount: @recipe.yield_amount, yield_description: @recipe.yield_description, yield_unit: @recipe.yield_unit } }
    assert_redirected_to recipe_url(@recipe.reload)
  end

  test "should destroy recipe" do
    assert_difference("Recipe.count", -1) do
      delete recipe_url(@recipe)
    end

    assert_redirected_to recipes_url
  end
end
