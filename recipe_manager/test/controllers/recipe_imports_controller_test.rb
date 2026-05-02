require "test_helper"

class RecipeImportsControllerTest < ActionDispatch::IntegrationTest
  test "imports a nested recipe payload" do
    payload = JSON.parse(File.read(Rails.root.join("..", "encacahuatado.json")))

    assert_difference("Recipe.count", 1) do
      assert_difference("RecipeIngredient.count", 7) do
        assert_difference("Step.count", 5) do
          post recipe_imports_url, params: payload, as: :json
        end
      end
    end

    assert_response :created

    response_body = JSON.parse(response.body)
    recipe = Recipe.find_by!(stable_id: response_body.fetch("stable_id"))

    assert_equal "soy-curl-encacahuatado", recipe.stable_id
    assert_equal 2, recipe.technique_notes.count
    assert_equal 2, recipe.substitutions.count
    assert_equal 2, recipe.substitutions.sum { |substitution| substitution.substitutes.count }
    assert_equal 3, recipe.adjustments.count
    assert recipe.storage.present?
    assert_equal recipe_url(recipe), response_body.fetch("url")
  end

  test "infers ingredient steps when nested payload omits step data" do
    payload = {
      title: "Inferred Ingredient Steps",
      version: "1.0",
      ingredients: [
        { name: "salt", amount: "1", unit: "tsp" },
        { name: "salt", amount: "to taste" },
        { name: "onion", amount: "1", unit: "medium" }
      ],
      steps: [
        { order: 1, action: "Cook the onion with salt." },
        { order: 2, action: "Taste and add more salt." }
      ]
    }

    post recipe_imports_url, params: payload, as: :json

    assert_response :created

    recipe = Recipe.find_by!(stable_id: "inferred-ingredient-steps")
    step_orders = recipe.recipe_ingredients.joins(:ingredient).order(:id).pluck("ingredients.name", :amount, :step_id).map do |name, amount, step_id|
      [ name, amount, Step.find(step_id).order ]
    end

    assert_equal [
      [ "salt", "1", 1 ],
      [ "salt", "to taste", 2 ],
      [ "onion", "1", 1 ]
    ], step_orders
  end
end
