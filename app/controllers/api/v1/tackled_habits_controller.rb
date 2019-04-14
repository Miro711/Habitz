class Api::V1::TackledHabitsController < Api::ApplicationController

    before_action :authenticate_user!
    before_action :authorize_tackle_create!, only: [:create, :show]
    before_action :authorize_tackle_destroy!, only: [:destroy]

    def create
        new_tackled_habit = TackledHabit.find_or_initialize_by(user_id: current_user.id, habit_id: habit.id)
        new_tackled_habit.habit = habit
        new_tackled_habit.is_reminder = tackled_habit_params["is_reminder"]
    
        checkin_date = tackled_habit_params["checkin_date"]

        if tackled_habit_params["checkin_value"] == "" || tackled_habit_params["checkin_value"] == nil
            parsed_checkin_value = nil
        else
            parsed_checkin_value = tackled_habit_params["checkin_value"].to_f
        end
    
        if new_tackled_habit.checkins.any?{|x| x["checkin_date"] == checkin_date}
            duplicate_index = new_tackled_habit.checkins.find_index{|x| x["checkin_date"] == checkin_date}
            if parsed_checkin_value != nil
                new_tackled_habit.checkins[duplicate_index]["checkin_value"] = parsed_checkin_value
                if habit.habit_type == 'Number' && habit.min_or_max == 'At least' && parsed_checkin_value >= habit.threshold
                    new_tackled_habit.checkins[duplicate_index]["is_win"] = true
                elsif habit.habit_type == 'Number' && habit.min_or_max == 'At most' && parsed_checkin_value <= habit.threshold
                    new_tackled_habit.checkins[duplicate_index]["is_win"] = true
                elsif habit.habit_type == 'Binary' 
                    new_tackled_habit.checkins[duplicate_index]["is_win"] = true
                else 
                    new_tackled_habit.checkins[duplicate_index]["is_win"] = false
                end
            else
                new_tackled_habit.checkins.delete_at(duplicate_index)
            end
        else
            status = false
            status = true if habit.habit_type == 'Binary'
            status = true if habit.habit_type == 'Number' && habit.min_or_max == 'At least' && parsed_checkin_value >= habit.threshold
            status = true if habit.habit_type == 'Number' && habit.min_or_max == 'At most' && parsed_checkin_value <= habit.threshold
            new_tackled_habit.checkins << {checkin_date: checkin_date, checkin_value: parsed_checkin_value, is_win: status}
        end

        new_tackled_habit.save!

        new_tackled_habit.wins = new_tackled_habit.checkins.select {|checkin| checkin["is_win"] == true}.count
        new_tackled_habit.checkins.sort_by!{|checkin| checkin["checkin_date"]}.reverse!
        
        if habit.habit_type == 'Binary'
            if new_tackled_habit.checkins.length == 1
                new_tackled_habit.current_streak = 1
                # new_tackled_habit.maximum_streak = 1
            else
                new_tackled_habit.current_streak = 1
                for index in 0..(new_tackled_habit.checkins.length-2)
                    if Date.parse(new_tackled_habit.checkins[index]["checkin_date"]) - Date.parse(new_tackled_habit.checkins[index+1]["checkin_date"]) > 1
                        # new_tackled_habit.current_streak = 0
                        break
                    else
                        new_tackled_habit.current_streak += 1
                    end
                end
            end
            new_tackled_habit.current_streak = 0 if Date.today - Date.parse(new_tackled_habit.checkins[0]["checkin_date"]) > 1
            # new_tackled_habit.maximum_streak = new_tackled_habit.current_streak if new_tackled_habit.current_streak > new_tackled_habit.maximum_streak
        elsif habit.habit_type == 'Number' && habit.min_or_max == 'At least'
            if new_tackled_habit.checkins.length == 1 && new_tackled_habit.checkins[0]["checkin_value"] >= habit.threshold
                new_tackled_habit.current_streak = 1
            else
                new_tackled_habit.current_streak = 1 if new_tackled_habit.checkins[0]["checkin_value"] >= habit.threshold
                new_tackled_habit.current_streak = 0 if new_tackled_habit.checkins[0]["checkin_value"] < habit.threshold
                for index in 0..(new_tackled_habit.checkins.length-2)
                    if Date.parse(new_tackled_habit.checkins[index]["checkin_date"]) - Date.parse(new_tackled_habit.checkins[index+1]["checkin_date"]) > 1
                        # new_tackled_habit.current_streak = 0
                        break
                    else
                        new_tackled_habit.current_streak += 1 if new_tackled_habit.checkins[index+1]["checkin_value"] >= habit.threshold
                        break if new_tackled_habit.checkins[index+1]["checkin_value"] < habit.threshold
                    end
                    # if (Date.parse(new_tackled_habit.checkins[index]["checkin_date"]) - Date.parse(new_tackled_habit.checkins[index+1]["checkin_date"])) <= 1 && ( new_tackled_habit.checkins[index]["checkin_value"] >= habit.threshold ) #&& ( new_tackled_habit.checkins[index+1]["checkin_value"] >= habit.threshold ) 
                    #     new_tackled_habit.current_streak += 1
                    # else
                    #     break
                    # end
                end
            end
            new_tackled_habit.current_streak = 0 if Date.today - Date.parse(new_tackled_habit.checkins[0]["checkin_date"]) > 1
        elsif habit.habit_type == 'Number' && habit.min_or_max == 'At most'
            if new_tackled_habit.checkins.length == 1 && new_tackled_habit.checkins[0]["checkin_value"] <= habit.threshold
                new_tackled_habit.current_streak = 1
            else
                new_tackled_habit.current_streak = 1 if new_tackled_habit.checkins[0]["checkin_value"] <= habit.threshold
                new_tackled_habit.current_streak = 0 if new_tackled_habit.checkins[0]["checkin_value"] > habit.threshold
                for index in 0..(new_tackled_habit.checkins.length-2)
                    if Date.parse(new_tackled_habit.checkins[index]["checkin_date"]) - Date.parse(new_tackled_habit.checkins[index+1]["checkin_date"]) > 1
                        # new_tackled_habit.current_streak = 0
                        break
                    else
                        new_tackled_habit.current_streak += 1 if new_tackled_habit.checkins[index+1]["checkin_value"] <= habit.threshold
                        break if new_tackled_habit.checkins[index+1]["checkin_value"] > habit.threshold
                    end
                    # if (Date.parse(new_tackled_habit.checkins[index]["checkin_date"]) - Date.parse(new_tackled_habit.checkins[index+1]["checkin_date"])) <= 1 && ( new_tackled_habit.checkins[index]["checkin_value"] <= habit.threshold ) #&& ( new_tackled_habit.checkins[index+1]["checkin_value"] <= habit.threshold ) 
                    #     new_tackled_habit.current_streak += 1
                    # end
                end
            end
            new_tackled_habit.current_streak = 0 if Date.today - Date.parse(new_tackled_habit.checkins[0]["checkin_date"]) > 1
        end
        
        new_tackled_habit.save!
        render json: {id: new_tackled_habit.id}
        
      end
    
      def destroy
        tackled_habit.destroy
        render json: { status: 200 }, status: 200
      end

      def show
        render json: tackled_habit
      end

    private

    def habit
        @habit ||= Habit.find params[:habit_id]
    end
    
    def tackled_habit
        @tackled_habit ||= TackledHabit.find params[:id]
    end

    def tackled_habit_params
        params.permit(:is_reminder, :checkin_date, :checkin_value)
        # params.require(:tackled_habit).permit(:is_reminder, :checkin_date, :checkin_value)
    end

    def authorize_tackle_create!
        render json: { status: 403 }, status: 403, alert: 'Access Forbidden: Not a habit you can tackle!' unless can? :show, habit
    end
    
    def authorize_tackle_destroy!
        render json: { status: 403 }, status: 403, alert: 'Access Forbidden: Not your tackle to delete!' unless can? :destroy, tackled_habit
    end

end
