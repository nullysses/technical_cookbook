class RecipeIngredientProgressesController < ApplicationController
  def update
    recipe_ingredient = RecipeIngredient.find(params.expect(:recipe_ingredient_id))
    progress = RecipeIngredientProgress.find_by(recipe_ingredient:, user_key: current_progress_user_key)

    if done?
      RecipeIngredientProgress.find_or_create_by!(recipe_ingredient:, user_key: current_progress_user_key)
    else
      progress&.destroy!
    end

    load_recipe_progress_state(recipe_ingredient.recipe)

    respond_to do |format|
      format.turbo_stream { render_progress_streams }
      format.html { redirect_to recipe_ingredient.recipe }
    end
  end

  private

  def done?
    ActiveModel::Type::Boolean.new.cast(params[:done])
  end

  def render_progress_streams
    render turbo_stream: [
      turbo_stream.replace("recipe_ingredients_section", partial: "recipes/recipe_ingredients_section"),
      turbo_stream.replace("steps_section", partial: "recipes/steps_section")
    ]
  end
end
