class AdjustmentsController < ApplicationController
  before_action :set_adjustment, only: %i[ show edit update destroy ]

  # GET /adjustments
  def index
    @adjustments = Adjustment.all
  end

  # GET /adjustments/1
  def show
  end

  # GET /adjustments/new
  def new
    @adjustment = Adjustment.new
  end

  # GET /adjustments/1/edit
  def edit
  end

  # POST /adjustments
  def create
    @adjustment = Adjustment.new(adjustment_params)

    if @adjustment.save
      redirect_to @adjustment, notice: "Adjustment was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /adjustments/1
  def update
    if @adjustment.update(adjustment_params)
      redirect_to @adjustment, notice: "Adjustment was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /adjustments/1
  def destroy
    @adjustment.destroy!
    redirect_to adjustments_path, notice: "Adjustment was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adjustment
      @adjustment = Adjustment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def adjustment_params
      params.expect(adjustment: [ :recipe_id, :condition, :fix ])
    end
end
