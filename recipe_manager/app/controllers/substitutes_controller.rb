class SubstitutesController < ApplicationController
  before_action :set_substitute, only: %i[ show edit update destroy ]

  # GET /substitutes
  def index
    @substitutes = Substitute.all
  end

  # GET /substitutes/1
  def show
  end

  # GET /substitutes/new
  def new
    @substitute = Substitute.new
  end

  # GET /substitutes/1/edit
  def edit
  end

  # POST /substitutes
  def create
    @substitute = Substitute.new(substitute_params)

    if @substitute.save
      redirect_to @substitute, notice: "Substitute was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /substitutes/1
  def update
    if @substitute.update(substitute_params)
      redirect_to @substitute, notice: "Substitute was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /substitutes/1
  def destroy
    @substitute.destroy!
    redirect_to substitutes_path, notice: "Substitute was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_substitute
      @substitute = Substitute.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def substitute_params
      params.expect(substitute: [ :substitution_id, :name, :ratio, :effect ])
    end
end
