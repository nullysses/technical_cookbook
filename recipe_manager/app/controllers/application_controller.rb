class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_progress_user_key

  private

  def current_progress_user_key
    session[:progress_user_key] ||= SecureRandom.uuid
  end

  def load_recipe_progress_state(recipe)
    @recipe = recipe
    @recipe_ingredients = recipe.recipe_ingredients.left_joins(:step).joins(:ingredient).preload(:ingredient, :step).order("steps.\"order\"", :section, "ingredients.name")
    @steps = recipe.steps.order(:order)
    @procured_recipe_ingredient_ids = RecipeIngredientProgress.where(
      recipe_ingredient: recipe.recipe_ingredients,
      user_key: current_progress_user_key
    ).pluck(:recipe_ingredient_id).to_set
    @done_step_ids = StepProgress.where(
      step: recipe.steps,
      user_key: current_progress_user_key
    ).pluck(:step_id).to_set
  end
end
