class CreateSubstitutions < ActiveRecord::Migration[8.1]
  def change
    create_table :substitutions do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :ingredient, null: false

      t.timestamps
    end
  end
end
