require "test_helper"

class RecipeProgressTest < ActionDispatch::IntegrationTest
  test "marks a recipe ingredient procured for the current session" do
    recipe_ingredient = recipe_ingredients(:one)

    assert_difference("RecipeIngredientProgress.count", 1) do
      patch recipe_ingredient_progress_url(recipe_ingredient), params: { done: "1" }
    end

    assert_redirected_to recipe_url(recipe_ingredient.recipe)
  end

  test "marking a step done marks related ingredients procured" do
    recipe = Recipe.create!(title: "Progress Test Recipe", version: "1.0")
    ingredient = Ingredient.create!(name: "water")
    step = recipe.steps.create!(order: 1, action: "Add water and stir.")
    recipe_ingredient = recipe.recipe_ingredients.create!(ingredient: ingredient, step: step)

    assert_difference("StepProgress.count", 1) do
      assert_difference("RecipeIngredientProgress.count", 1) do
        patch step_progress_url(step), params: { done: "1" }
      end
    end

    assert_redirected_to recipe_url(recipe)
    assert RecipeIngredientProgress.exists?(recipe_ingredient: recipe_ingredient)
  end

  test "step progress responds with turbo stream section replacements" do
    recipe = Recipe.create!(title: "Turbo Progress Test Recipe", version: "1.0")
    ingredient = Ingredient.create!(name: "turbo water")
    step = recipe.steps.create!(order: 1, action: "Add turbo water.")
    recipe.recipe_ingredients.create!(ingredient: ingredient, step: step)

    patch step_progress_url(step), params: { done: "1" }, headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "recipe_ingredients_section"
    assert_includes response.body, "steps_section"
  end

  test "same ingredient can be tied to different steps in one recipe" do
    recipe = Recipe.create!(title: "Repeated Ingredient Recipe", version: "1.0")
    salt = Ingredient.create!(name: "test salt")
    first_step = recipe.steps.create!(order: 1, action: "Add salt.")
    second_step = recipe.steps.create!(order: 2, action: "Add more salt.")

    first_usage = recipe.recipe_ingredients.create!(ingredient: salt, step: first_step, amount: "1", unit: "tsp")
    second_usage = recipe.recipe_ingredients.create!(ingredient: salt, step: second_step, amount: "to taste")

    assert_equal [ first_usage, second_usage ], recipe.recipe_ingredients.left_joins(:step).order("steps.\"order\"").to_a
  end

  test "recipe index shows in progress badge for current session progress" do
    recipe_ingredient = recipe_ingredients(:one)
    patch recipe_ingredient_progress_url(recipe_ingredient), params: { done: "1" }

    get recipes_url

    assert_response :success
    assert_select ".status-badge", text: "In progress"
  end
end
