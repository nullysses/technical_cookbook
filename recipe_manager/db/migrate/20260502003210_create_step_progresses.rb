class CreateStepProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :step_progresses do |t|
      t.references :step, null: false, foreign_key: true
      t.string :user_key, null: false

      t.timestamps
    end

    add_index :step_progresses, [ :step_id, :user_key ], unique: true
  end
end
