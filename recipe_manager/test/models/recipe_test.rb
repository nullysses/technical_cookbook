require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  test "infers stable id from title" do
    recipe = Recipe.create!(title: "Tacos & Salsa Roja!", version: "1.0")

    assert_equal "tacos-salsa-roja", recipe.stable_id
  end

  test "uses stable id as route parameter" do
    recipe = recipes(:one)

    assert_equal recipe.stable_id, recipe.to_param
  end
end
