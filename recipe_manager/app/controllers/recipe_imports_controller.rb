class RecipeImportsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    recipe = NestedRecipeImporter.call(parsed_body)

    render json: {
      id: recipe.id,
      stable_id: recipe.stable_id,
      title: recipe.title,
      url: recipe_url(recipe)
    }, status: :created
  rescue KeyError, ActiveRecord::RecordInvalid => error
    render json: { error: error.message }, status: :unprocessable_content
  end

  private

  def parsed_body
    request.request_parameters.presence || JSON.parse(request.raw_post)
  end
end
