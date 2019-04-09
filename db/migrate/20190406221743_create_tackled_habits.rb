class CreateTackledHabits < ActiveRecord::Migration[5.2]
  def change
    create_table :tackled_habits do |t|
      t.references :user, foreign_key: true
      t.references :habit, foreign_key: true
      t.json :checkins, default: []
      t.boolean :is_reminder, default: false
      t.integer :current_streak
      t.integer :maximum_streak
      t.integer :number_of_attempts
      t.float :success_percent

      t.timestamps
    end
  end
end
