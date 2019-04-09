class Api::V1::TackledHabitsController < Api::ApplicationController

    before_action :authenticate_user!
    # before_action :set_habit, only: [:create]
    # before_action :set_tackled_habit, only: [:destroy]
    before_action :authorize_tackle_create!, only: [:create]
    before_action :authorize_tackle_destroy!, only: [:destroy]

    def create
        new_tackled_habit = TackledHabit.find_or_initialize_by(user_id: current_user.id, habit_id: habit.id)
        new_tackled_habit.habit = habit
        new_tackled_habit.is_reminder = tackled_habit_params["is_reminder"]
    
        checkin_date = tackled_habit_params["checkin_date"]
    
        if new_tackled_habit.checkins.any?{|x| x["checkin_date"] == checkin_date}
            duplicate_index = new_tackled_habit.checkins.find_index{|x| x["checkin_date"] == checkin_date}
            if tackled_habit_params["checkin_value"] != ""
                new_tackled_habit.checkins[duplicate_index]["checkin_value"] = tackled_habit_params["checkin_value"]
            else
                new_tackled_habit.checkins.delete_at(duplicate_index)
            end
        else
            new_tackled_habit.checkins << {checkin_date: checkin_date, checkin_value: tackled_habit_params["checkin_value"]}
        end
    
        new_tackled_habit.save!
        render json: {id: new_tackled_habit.id}
        
      end
    
      def destroy
        tackled_habit.destroy
        render json: { status: 200 }, status: 200
      end

    private

    def set_habit
        @habit ||= Habit.find params[:habit_id]
    end
    
    def set_tackled_habit
        @tackled_habit ||= TackledHabit.find params[:id]
    end

    def tackled_habit_params
        params.require(:tackled_habit).permit(:is_reminder, :checkin_date, :checkin_value)
    end

    def authorize_tackle_create!
        render json: { status: 403 }, status: 403, alert: 'Access Forbidden: Not a habit you can tackle!' unless can? :show, habit
    end
    
    def authorize_tackle_destroy!
        render json: { status: 403 }, status: 403, alert: 'Access Forbidden: Not your tackle to delete!' unless can? :destroy, tackled_habit
    end

end
