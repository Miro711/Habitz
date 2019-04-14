class TackledHabitSerializer < ActiveModel::Serializer
  
  attributes :id, :habit_id, :created_at, :updated_at, :checkins, :is_reminder, :current_streak, :wins
  #, :maximum_streak, :number_of_attempts, :success_percent
  
  belongs_to :user, key: :habit_tackler
  # belongs_to :habit

end
