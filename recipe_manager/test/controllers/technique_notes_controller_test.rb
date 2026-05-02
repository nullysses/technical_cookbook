require "test_helper"

class TechniqueNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @technique_note = technique_notes(:one)
  end

  test "should get index" do
    get technique_notes_url
    assert_response :success
  end

  test "should get new" do
    get new_technique_note_url
    assert_response :success
  end

  test "should create technique_note" do
    assert_difference("TechniqueNote.count") do
      post technique_notes_url, params: { technique_note: { note: @technique_note.note, recipe_id: @technique_note.recipe_id, topic: @technique_note.topic } }
    end

    assert_redirected_to technique_note_url(TechniqueNote.last)
  end

  test "should show technique_note" do
    get technique_note_url(@technique_note)
    assert_response :success
  end

  test "should get edit" do
    get edit_technique_note_url(@technique_note)
    assert_response :success
  end

  test "should update technique_note" do
    patch technique_note_url(@technique_note), params: { technique_note: { note: @technique_note.note, recipe_id: @technique_note.recipe_id, topic: @technique_note.topic } }
    assert_redirected_to technique_note_url(@technique_note)
  end

  test "should destroy technique_note" do
    assert_difference("TechniqueNote.count", -1) do
      delete technique_note_url(@technique_note)
    end

    assert_redirected_to technique_notes_url
  end
end
