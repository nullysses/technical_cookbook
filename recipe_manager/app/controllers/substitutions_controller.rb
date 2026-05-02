class SubstitutionsController < ApplicationController
  before_action :set_substitution, only: %i[ show edit update destroy ]

  # GET /substitutions
  def index
    @substitutions = Substitution.all
  end

  # GET /substitutions/1
  def show
  end

  # GET /substitutions/new
  def new
    @substitution = Substitution.new
  end

  # GET /substitutions/1/edit
  def edit
  end

  # POST /substitutions
  def create
    @substitution = Substitution.new(substitution_params)

    if @substitution.save
      redirect_to @substitution, notice: "Substitution was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /substitutions/1
  def update
    if @substitution.update(substitution_params)
      redirect_to @substitution, notice: "Substitution was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /substitutions/1
  def destroy
    @substitution.destroy!
    redirect_to substitutions_path, notice: "Substitution was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_substitution
      @substitution = Substitution.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def substitution_params
      params.expect(substitution: [ :recipe_id, :ingredient ])
    end
end
