class TackledHabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tackled_habit, only: [:destroy]
  before_action :authorize_user!, only: [:destroy]

  def create
    @habit = Habit.find params[:habit_id]
    @tackled_habit = TackledHabit.find_or_initialize_by(user_id: current_user.id, habit_id: @habit.id)
    @tackled_habit.habit = @habit
    @tackled_habit.is_reminder = tackled_habit_params["is_reminder"]

    parsed_checkin_date = Date.parse(tackled_habit_params["checkin_date"])

    if @tackled_habit.checkin_dates.include? parsed_checkin_date
        duplicate_index = @tackled_habit.checkin_dates.find_index(parsed_checkin_date)
        if tackled_habit_params["checkin_value"] != ""
            @tackled_habit.checkin_values[duplicate_index] = tackled_habit_params["checkin_value"]
        else
            @tackled_habit.checkin_values.delete_at(duplicate_index)
            @tackled_habit.checkin_dates.delete(parsed_checkin_date)
        end
    else
        @tackled_habit.checkin_dates << parsed_checkin_date
        @tackled_habit.checkin_values << tackled_habit_params["checkin_value"]
    end
    # @tackled_habit.checkin_dates.sort! 

    if @tackled_habit.save
      redirect_to habit_url(@habit.id)
    else
      @tackled_habits = @habit.tackled_habits.order(created_at: :desc)
      render "habits/show"
    end
  end

  def destroy
    @tackled_habit.destroy

    redirect_to habit_url(@tackled_habit.habit)
  end

  private

  def set_tackled_habit
    @tackled_habit = TackledHabit.find params[:id]
  end

  def tackled_habit_params
    params.require(:tackled_habit).permit(:is_reminder, :checkin_date, :checkin_value)
  end

  def authorize_user!
    redirect_to habit_url(@tackled_habit.habit), alert: 'Access Denied' unless can? :crud, @tackled_habit
  end

end
