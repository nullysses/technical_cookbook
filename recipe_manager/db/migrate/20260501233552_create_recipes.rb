class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :stable_id, null: false
      t.string :title, null: false
      t.string :version, null: false
      t.string :language
      t.text :diet
      t.text :tags
      t.text :equipment
      t.text :nutrition_notes
      t.decimal :servings_count
      t.string :servings_unit
      t.decimal :yield_amount
      t.string :yield_unit
      t.string :yield_description
      t.string :source_created_from
      t.text :source_notes

      t.timestamps
    end

    add_index :recipes, :stable_id, unique: true
  end
end
