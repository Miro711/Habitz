class HabitSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :name,
    :description,
    :habit_type,
    :threshold,
    :unit,
    :min_or_max,
    :target_streak,
    :is_public,
    :created_at,
    :updated_at
    # :frequency,
    # :number_of_days,
  )

  belongs_to :user, key: :habit_owner
  has_many :tackled_habits

  # class TackledHabitSerializer < ActiveModel::Serializer
  #   attributes :id, :habit_id, :created_at, :updated_at, :checkins, :is_reminder, :current_streak, :maximum_streak, :number_of_attempts, :success_percent
  #   belongs_to :user, key: :habit_tackler
  #   belongs_to :habit
  # end

end
