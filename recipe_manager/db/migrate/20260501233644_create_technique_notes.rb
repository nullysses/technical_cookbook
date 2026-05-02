class CreateTechniqueNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :technique_notes do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :topic, null: false
      t.text :note, null: false

      t.timestamps
    end
  end
end
