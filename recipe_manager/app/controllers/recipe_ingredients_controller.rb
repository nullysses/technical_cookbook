class RecipeIngredientsController < ApplicationController
  before_action :set_recipe_ingredient, only: %i[ show edit update destroy ]

  # GET /recipe_ingredients
  def index
    @recipe_ingredients = RecipeIngredient.joins(:recipe, :ingredient).left_joins(:step).preload(:recipe, :ingredient, :step).order("recipes.title", "steps.\"order\"", :section, "ingredients.name")
  end

  # GET /recipe_ingredients/1
  def show
  end

  # GET /recipe_ingredients/new
  def new
    @recipe_ingredient = RecipeIngredient.new
    set_form_collections
  end

  # GET /recipe_ingredients/1/edit
  def edit
    set_form_collections
  end

  # POST /recipe_ingredients
  def create
    @recipe_ingredient = RecipeIngredient.new(recipe_ingredient_params)

    if @recipe_ingredient.save
      redirect_to @recipe_ingredient, notice: "Recipe ingredient was successfully created."
    else
      set_form_collections
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /recipe_ingredients/1
  def update
    if @recipe_ingredient.update(recipe_ingredient_params)
      redirect_to @recipe_ingredient, notice: "Recipe ingredient was successfully updated.", status: :see_other
    else
      set_form_collections
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /recipe_ingredients/1
  def destroy
    recipe = @recipe_ingredient.recipe
    @recipe_ingredient.destroy!
    load_recipe_progress_state(recipe)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("recipe_ingredients_section", partial: "recipes/recipe_ingredients_section") }
      format.html { redirect_to recipe_path(recipe), notice: "Recipe ingredient was successfully destroyed.", status: :see_other }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe_ingredient
      @recipe_ingredient = RecipeIngredient.find(params.expect(:id))
    end

    def set_form_collections
      @recipes = Recipe.order(:title)
      @ingredients = Ingredient.order(:name)
      @steps = Step.includes(:recipe).order("recipes.title", :order)
    end

    # Only allow a list of trusted parameters through.
    def recipe_ingredient_params
      params.expect(recipe_ingredient: [ :recipe_id, :ingredient_id, :step_id, :amount, :unit, :state, :preparation, :section, :optional, :notes ])
    end
end
