json.extract! habit, :id, :user_id, :name, :description, :habit_type, :threshold, :unit, :min_or_max, :target_streak, :is_public, :frequency, :number_of_days, :created_at, :updated_at
json.url habit_url(habit, format: :json)
