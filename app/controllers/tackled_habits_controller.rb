class TackledHabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: [:create]
  before_action :set_tackled_habit, only: [:destroy]
  before_action :authorize_tackle_create!, only: [:create]
  before_action :authorize_tackle_destroy!, only: [:destroy]

  def create
    @tackled_habit = TackledHabit.find_or_initialize_by(user_id: current_user.id, habit_id: @habit.id)
    @tackled_habit.habit = @habit
    @tackled_habit.is_reminder = tackled_habit_params["is_reminder"]

    checkin_date = tackled_habit_params["checkin_date"]

    if @tackled_habit.checkins.any?{|x| x["checkin_date"] == checkin_date}
        duplicate_index = @tackled_habit.checkins.find_index{|x| x["checkin_date"] == checkin_date}
        if tackled_habit_params["checkin_value"] != ""
            @tackled_habit.checkins[duplicate_index]["checkin_value"] = tackled_habit_params["checkin_value"]
        else
            @tackled_habit.checkins.delete_at(duplicate_index)
        end
    else
        @tackled_habit.checkins << {checkin_date: checkin_date, checkin_value: tackled_habit_params["checkin_value"]}
    end

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

  def set_habit
    @habit = Habit.find params[:habit_id]
  end

  def set_tackled_habit
    @tackled_habit = TackledHabit.find params[:id]
  end

  def tackled_habit_params
    params.require(:tackled_habit).permit(:is_reminder, :checkin_date, :checkin_value)
  end

  def authorize_tackle_create!
    redirect_to new_habit_url, alert: 'Access Denied: Not a habit you can tackle!' unless can? :show, @habit
  end

  def authorize_tackle_destroy!
    redirect_to habit_url(@tackled_habit.habit), alert: 'Access Denied: Not your tackle to delete!' unless can? :destroy, @tackled_habit
  end

end
