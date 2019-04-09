class Api::V1::HabitsController < Api::ApplicationController
    
    before_action :authenticate_user!, except: [:index_public]
    # before_action :set_habit, only: [:show, :edit, :update, :destroy]
    before_action :authorize_habit_crud!, only: [:edit, :update]
    before_action :authorize_habit_show!, only: [:show]
    before_action :authorize_habit_destroy!, only: [:destroy]

    def index
        habits = Habit.where(user_id: current_user.id).order(created_at: :desc).to_a.concat(
                    TackledHabit.where(user_id: current_user.id).order(created_at: :desc).select{|x| 
                        x.habit.user != current_user
                    }.map{|x| x.habit}
                )
        render json: habits
    end

    def show
        render json: habit
    end

    def create
        habit = Habit.new(habit_params)
        habit.user = current_user
        habit.save!
        render json: { id: habit.id, notice: 'Habit profile was successfully created.' }
        # format.json { render :show, status: :created, location: @habit, notice: 'Habit profile was successfully created.' }
        # render json: { errors: habit.errors }, status: 422
        # format.json { render json: @habit.errors, status: :unprocessable_entity }
    end

    def destroy
        habit.destroy
        render json: { status: 200 }, status: 200
        #render json: { head :no_content, notice: 'Habit profile was successfully destroyed.' }
    end

    def index_public
        habits = Habit.where(is_public: true).order(created_at: :desc)
        render json: habits
    end

    private

    def habit
        @habit ||= Habit.find params[:id]
    end

    def habit_params
        params.permit(:name, :description, :habit_type, :threshold, :unit, :min_or_max, :target_streak, :is_public, :frequency, :number_of_days)
    end

    def authorize_habit_crud!
        render json: { status: 403 }, status: 403, alert: 'Access Forbidden' unless can? :crud, habit
    end
  
    def authorize_habit_show!
        render json: { status: 403 }, status: 403, alert: 'Access Forbidden' unless can? :show, habit
    end
  
    def authorize_habit_destroy!
        render json: { status: 403 }, status: 403, alert: 'Access Forbidden' unless can? :destroy, habit
    end

end
