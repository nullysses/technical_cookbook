class MoveRecipeFieldsFromIngredientsToRecipeIngredients < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL.squish
      INSERT INTO recipe_ingredients (
        recipe_id,
        ingredient_id,
        amount,
        unit,
        state,
        preparation,
        section,
        optional,
        notes,
        created_at,
        updated_at
      )
      SELECT
        recipe_id,
        id,
        amount,
        unit,
        state,
        preparation,
        section,
        optional,
        notes,
        created_at,
        updated_at
      FROM ingredients
      WHERE recipe_id IS NOT NULL
    SQL

    remove_index :ingredients, name: "index_ingredients_on_recipe_id_and_section_and_name", if_exists: true
    remove_reference :ingredients, :recipe, foreign_key: true, index: true
    remove_columns :ingredients, :amount, :unit, :state, :preparation, :section, :optional, :notes
    add_index :ingredients, :name
  end

  def down
    remove_index :ingredients, :name, if_exists: true
    add_column :ingredients, :amount, :string
    add_column :ingredients, :unit, :string
    add_column :ingredients, :state, :string
    add_column :ingredients, :preparation, :string
    add_column :ingredients, :section, :string
    add_column :ingredients, :optional, :boolean
    add_column :ingredients, :notes, :text
    add_reference :ingredients, :recipe, foreign_key: true
    add_index :ingredients, [ :recipe_id, :section, :name ]
  end
end
