class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]


  # GET /notes or /notes.json
  def index
    @notes = current_user.notes
  end

  # GET /notes/1 or /notes/1.json
  def show
    if current_user.id != @note.user_id
      redirect_to books_url, notice: "The note you are trying to access is not yours, don't spy on other people notes :P"
    end
  end

  # GET /notes/new
  def new
    @note = current_user.notes.build
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    puts note_params
    @note = Note.new(note_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      # format.json { head :no_content }
    end
  end

  def export
    @note = Note.find(params[:id])
    respond_to do |format|
      format.html { send_data @note.export_html, filename: "note_#{@note.title}.html", notice: "Note was successfully exported." }
      # format.json { head :no_content }
    end
  end

  def export_all
    respond_to do |format|
      format.html { send_data current_user.export_data_zip, filename: "all_notes.zip", notice: "All notes have been exported." }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :content, :book_id)
    end
end
