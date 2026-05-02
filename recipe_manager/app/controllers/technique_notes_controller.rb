class TechniqueNotesController < ApplicationController
  before_action :set_technique_note, only: %i[ show edit update destroy ]

  # GET /technique_notes
  def index
    @technique_notes = TechniqueNote.all
  end

  # GET /technique_notes/1
  def show
  end

  # GET /technique_notes/new
  def new
    @technique_note = TechniqueNote.new
  end

  # GET /technique_notes/1/edit
  def edit
  end

  # POST /technique_notes
  def create
    @technique_note = TechniqueNote.new(technique_note_params)

    if @technique_note.save
      redirect_to @technique_note, notice: "Technique note was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /technique_notes/1
  def update
    if @technique_note.update(technique_note_params)
      redirect_to @technique_note, notice: "Technique note was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /technique_notes/1
  def destroy
    @technique_note.destroy!
    redirect_to technique_notes_path, notice: "Technique note was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_technique_note
      @technique_note = TechniqueNote.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def technique_note_params
      params.expect(technique_note: [ :recipe_id, :topic, :note ])
    end
end
