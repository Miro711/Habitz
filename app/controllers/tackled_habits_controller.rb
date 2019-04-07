class TackledHabitsController < ApplicationController
  before_action :authenticate_user!

  def create
    @habit = Habit.find params[:habit_id]
    @tackled_habit = TackledHabit.find_or_initialize_by(user_id: current_user.id)
    @tackled_habit.habit = @habit
    @tackled_habit.is_reminder = tackled_habit_params["is_reminder"]
    if @tackled_habit.checkin_dates.include? Date.parse(tackled_habit_params["checkin_date"])
        if tackled_habit_params["checkin_value"] != ""
            @tackled_habit.checkin_values[@tackled_habit.checkin_dates.find_index(Date.parse(tackled_habit_params["checkin_date"]))] = tackled_habit_params["checkin_value"]
        else
            @tackled_habit.checkin_values.delete_at(@tackled_habit.checkin_dates.find_index(Date.parse(tackled_habit_params["checkin_date"])))
            @tackled_habit.checkin_dates.delete(Date.parse(tackled_habit_params["checkin_date"]))
        end
    else
        @tackled_habit.checkin_dates << tackled_habit_params["checkin_date"]
        @tackled_habit.checkin_values << tackled_habit_params["checkin_value"]
    end

    if @tackled_habit.save
      redirect_to habit_url(@habit.id)
    else
      @tackled_habits = @habit.tackled_habits.order(created_at: :desc)
      render "habits/show"
    end
  end

  def destroy
    @tackled_habit = TackledHabit.find params[:id]
    @tackled_habit.destroy

    redirect_to habit_url(@tackled_habit.habit)
  end

  private

  def tackled_habit_params
    params.require(:tackled_habit).permit(:is_reminder, :checkin_date, :checkin_value)
  end
end
