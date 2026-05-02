class StepsController < ApplicationController
  before_action :set_step, only: %i[ show edit update destroy ]

  # GET /steps
  def index
    @steps = Step.all
  end

  # GET /steps/1
  def show
  end

  # GET /steps/new
  def new
    @step = Step.new
  end

  # GET /steps/1/edit
  def edit
  end

  # POST /steps
  def create
    @step = Step.new(step_params)

    if @step.save
      redirect_to @step.recipe, notice: "Step was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /steps/1
  def update
    if @step.update(step_params)
      redirect_to @step.recipe, notice: "Step was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /steps/1
  def destroy
    recipe = @step.recipe
    @step.destroy!
    redirect_to recipe, notice: "Step was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_step
      @step = Step.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def step_params
      params.expect(step: [ :recipe_id, :order, :title, :action, :time_amount, :time_unit, :time_per_side, :time_description, :temperature_amount, :temperature_unit, :temperature_description, :heat_level, :targets, :risk_points, :notes, :optional_data ])
    end
end
