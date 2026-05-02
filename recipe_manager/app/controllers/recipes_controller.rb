class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show edit update destroy ]

  # GET /recipes
  def index
    @recipes = Recipe.includes(:recipe_ingredients, :steps).order(:title)
    @in_progress_recipe_ids = in_progress_recipe_ids
  end

  # GET /recipes/:stable_id
  def show
    load_recipe_progress_state(@recipe)
    @technique_notes = @recipe.technique_notes.order(:topic)
    @substitutions = @recipe.substitutions.includes(:substitutes).order(:ingredient)
    @adjustments = @recipe.adjustments.order(:condition)
    @storage = @recipe.storage
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/:stable_id/edit
  def edit
  end

  # POST /recipes
  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: "Recipe was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /recipes/:stable_id
  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy!
    redirect_to recipes_path, notice: "Recipe was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find_by!(stable_id: params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.expect(recipe: [ :title, :version, :language, :diet, :tags, :equipment, :nutrition_notes, :servings_count, :servings_unit, :yield_amount, :yield_unit, :yield_description, :source_created_from, :source_notes ])
    end

    def in_progress_recipe_ids
      recipe_ids_from_ingredients = RecipeIngredientProgress
        .joins(:recipe_ingredient)
        .where(user_key: current_progress_user_key)
        .distinct
        .pluck("recipe_ingredients.recipe_id")

      recipe_ids_from_steps = StepProgress
        .joins(:step)
        .where(user_key: current_progress_user_key)
        .distinct
        .pluck("steps.recipe_id")

      (recipe_ids_from_ingredients + recipe_ids_from_steps).to_set
    end
end
