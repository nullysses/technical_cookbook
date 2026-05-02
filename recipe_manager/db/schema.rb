# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_02_005200) do
  create_table "adjustments", force: :cascade do |t|
    t.text "condition", null: false
    t.datetime "created_at", null: false
    t.text "fix", null: false
    t.integer "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_adjustments_on_recipe_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name"
  end

  create_table "recipe_ingredient_progresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "recipe_ingredient_id", null: false
    t.datetime "updated_at", null: false
    t.string "user_key", null: false
    t.index ["recipe_ingredient_id", "user_key"], name: "idx_on_recipe_ingredient_id_user_key_0bf5b4a28f", unique: true
    t.index ["recipe_ingredient_id"], name: "index_recipe_ingredient_progresses_on_recipe_ingredient_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.string "amount"
    t.datetime "created_at", null: false
    t.integer "ingredient_id", null: false
    t.text "notes"
    t.boolean "optional"
    t.string "preparation"
    t.integer "recipe_id", null: false
    t.string "section"
    t.string "state"
    t.integer "step_id"
    t.string "unit"
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id", "ingredient_id"], name: "index_recipe_ingredients_on_recipe_id_and_ingredient_id"
    t.index ["recipe_id", "section"], name: "index_recipe_ingredients_on_recipe_id_and_section"
    t.index ["recipe_id", "step_id"], name: "index_recipe_ingredients_on_recipe_id_and_step_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
    t.index ["step_id"], name: "index_recipe_ingredients_on_step_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "diet"
    t.text "equipment"
    t.string "language"
    t.text "nutrition_notes"
    t.decimal "servings_count"
    t.string "servings_unit"
    t.string "source_created_from"
    t.text "source_notes"
    t.string "stable_id", null: false
    t.text "tags"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "version", null: false
    t.decimal "yield_amount"
    t.string "yield_description"
    t.string "yield_unit"
    t.index ["stable_id"], name: "index_recipes_on_stable_id", unique: true
  end

  create_table "step_progresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "step_id", null: false
    t.datetime "updated_at", null: false
    t.string "user_key", null: false
    t.index ["step_id", "user_key"], name: "index_step_progresses_on_step_id_and_user_key", unique: true
    t.index ["step_id"], name: "index_step_progresses_on_step_id"
  end

  create_table "steps", force: :cascade do |t|
    t.text "action", null: false
    t.datetime "created_at", null: false
    t.string "heat_level"
    t.text "notes"
    t.text "optional_data"
    t.integer "order", null: false
    t.integer "recipe_id", null: false
    t.text "risk_points"
    t.text "targets"
    t.decimal "temperature_amount"
    t.string "temperature_description"
    t.string "temperature_unit"
    t.string "time_amount"
    t.string "time_description"
    t.boolean "time_per_side"
    t.string "time_unit"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["recipe_id", "order"], name: "index_steps_on_recipe_id_and_order"
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "storages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "freezer_duration"
    t.string "freezer_unit"
    t.integer "recipe_id", null: false
    t.decimal "refrigerator_duration"
    t.string "refrigerator_unit"
    t.text "reheat"
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_storages_on_recipe_id", unique: true
  end

  create_table "substitutes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "effect"
    t.string "name", null: false
    t.string "ratio"
    t.integer "substitution_id", null: false
    t.datetime "updated_at", null: false
    t.index ["substitution_id"], name: "index_substitutes_on_substitution_id"
  end

  create_table "substitutions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ingredient", null: false
    t.integer "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_substitutions_on_recipe_id"
  end

  create_table "technique_notes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "note", null: false
    t.integer "recipe_id", null: false
    t.string "topic", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_technique_notes_on_recipe_id"
  end

  add_foreign_key "adjustments", "recipes"
  add_foreign_key "recipe_ingredient_progresses", "recipe_ingredients"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipe_ingredients", "steps"
  add_foreign_key "step_progresses", "steps"
  add_foreign_key "steps", "recipes"
  add_foreign_key "storages", "recipes"
  add_foreign_key "substitutes", "substitutions"
  add_foreign_key "substitutions", "recipes"
  add_foreign_key "technique_notes", "recipes"
end
