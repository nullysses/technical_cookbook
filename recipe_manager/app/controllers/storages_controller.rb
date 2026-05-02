class StoragesController < ApplicationController
  before_action :set_storage, only: %i[ show edit update destroy ]

  # GET /storages
  def index
    @storages = Storage.all
  end

  # GET /storages/1
  def show
  end

  # GET /storages/new
  def new
    @storage = Storage.new
  end

  # GET /storages/1/edit
  def edit
  end

  # POST /storages
  def create
    @storage = Storage.new(storage_params)

    if @storage.save
      redirect_to @storage, notice: "Storage was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /storages/1
  def update
    if @storage.update(storage_params)
      redirect_to @storage, notice: "Storage was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /storages/1
  def destroy
    @storage.destroy!
    redirect_to storages_path, notice: "Storage was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_storage
      @storage = Storage.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def storage_params
      params.expect(storage: [ :recipe_id, :refrigerator_duration, :refrigerator_unit, :freezer_duration, :freezer_unit, :reheat ])
    end
end
