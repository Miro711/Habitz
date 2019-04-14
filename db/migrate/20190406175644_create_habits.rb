class CreateHabits < ActiveRecord::Migration[5.2]
  def change
    create_table :habits do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.text :description
      t.string :habit_type
      t.float :threshold
      t.string :unit
      t.string :min_or_max
      t.integer :target_streak
      t.boolean :is_public, default: false
      #t.string :frequency
      #t.integer :number_of_days

      t.timestamps
    end
  end
end
