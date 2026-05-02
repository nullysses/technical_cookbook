class CreateSubstitutes < ActiveRecord::Migration[8.1]
  def change
    create_table :substitutes do |t|
      t.references :substitution, null: false, foreign_key: true
      t.string :name, null: false
      t.string :ratio
      t.text :effect

      t.timestamps
    end
  end
end
