require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  test "infers stable_id from title on create" do
    recipe = Recipe.create!(title: "Tacos & Salsa Roja!", version: "1.0")

    assert_equal "tacos-salsa-roja", recipe.stable_id
  end

  test "does not change stable_id when title changes" do
    recipe = Recipe.create!(title: "BBQ Seitan Ribs", version: "v1")

    recipe.update!(title: "Better BBQ Seitan Ribs")

    assert_equal "bbq-seitan-ribs", recipe.reload.stable_id
  end

  test "preserves manually supplied stable_id" do
    recipe = Recipe.create!(
      title: "BBQ Seitan Ribs",
      version: "v1",
      stable_id: "custom-seitan-ribs"
    )

    assert_equal "custom-seitan-ribs", recipe.stable_id
  end

  test "adds numeric suffix when generated stable_id collides" do
    Recipe.create!(title: "BBQ Seitan", version: "v1")
    second = Recipe.create!(title: "BBQ Seitan", version: "v2")
    third = Recipe.create!(title: "BBQ Seitan", version: "v3")

    assert_equal "bbq-seitan-2", second.stable_id
    assert_equal "bbq-seitan-3", third.stable_id
  end

  test "rejects invalid stable_id format" do
    recipe = Recipe.new(
      title: "BBQ Seitan",
      version: "v1",
      stable_id: "BBQ Seitan"
    )

    assert_not recipe.valid?
    assert_includes recipe.errors[:stable_id], "must use lowercase letters, numbers, and single hyphens"
  end

  test "does not generate stable_id when title is blank" do
    recipe = Recipe.new(title: "", version: "v1")

    assert_not recipe.valid?
    assert_includes recipe.errors[:title], "can't be blank"
    assert_includes recipe.errors[:stable_id], "can't be blank"
  end

  test "uses stable_id as route parameter" do
    recipe = recipes(:one)

    assert_equal recipe.stable_id, recipe.to_param
  end
end
