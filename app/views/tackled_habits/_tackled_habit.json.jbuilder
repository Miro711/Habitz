json.extract! tackled_habit, :id, :user_id, :habit_id, :is_reminder, :current_streak, :maximum_streak, :number_of_attempts, :success_percent, :created_at, :updated_at
json.url tackled_habit_url(tackled_habit, format: :json)
