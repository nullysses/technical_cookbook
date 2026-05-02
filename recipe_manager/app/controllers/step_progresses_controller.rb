class StepProgressesController < ApplicationController
  def update
    step = Step.find(params.expect(:step_id))
    progress = StepProgress.find_by(step:, user_key: current_progress_user_key)

    if done?
      StepProgress.find_or_create_by!(step:, user_key: current_progress_user_key)
      mark_related_ingredients_procured(step)
    else
      progress&.destroy!
    end

    load_recipe_progress_state(step.recipe)

    respond_to do |format|
      format.turbo_stream { render_progress_streams }
      format.html { redirect_to step.recipe }
    end
  end

  private

  def done?
    ActiveModel::Type::Boolean.new.cast(params[:done])
  end

  def mark_related_ingredients_procured(step)
    step.recipe_ingredients.each do |recipe_ingredient|
      RecipeIngredientProgress.find_or_create_by!(
        recipe_ingredient: recipe_ingredient,
        user_key: current_progress_user_key
      )
    end
  end

  def render_progress_streams
    render turbo_stream: [
      turbo_stream.replace("recipe_ingredients_section", partial: "recipes/recipe_ingredients_section"),
      turbo_stream.replace("steps_section", partial: "recipes/steps_section")
    ]
  end
end
