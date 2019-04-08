class HabitsController < ApplicationController
  before_action :authenticate_user!, except: [:index_public]
  before_action :set_habit, only: [:show, :edit, :update, :destroy]
  before_action :authorize_habit_crud!, only: [:edit, :update]
  before_action :authorize_habit_show!, only: [:show]
  before_action :authorize_habit_destroy!, only: [:destroy]

  # GET /habits
  # GET /habits.json
  def index
    @habits = Habit.where(user_id: current_user.id).to_a.concat(TackledHabit.where(user_id: current_user.id).select{|x| 
                x.habit.user != current_user
              }.map{|x| x.habit})
  end

  # GET /habits/1
  # GET /habits/1.json
  def show
    @tackled_habit = TackledHabit.new
    @tackled_habits = @habit.tackled_habits.order(created_at: :desc)
  end

  # GET /habits/new
  def new
    @habit = Habit.new
  end

  # GET /habits/1/edit
  def edit
  end

  # POST /habits
  # POST /habits.json
  def create
    @habit = Habit.new(habit_params)
    @habit.user = current_user

    respond_to do |format|
      if @habit.save
        format.html { redirect_to @habit, notice: 'Habit profile was successfully created.' }
        format.json { render :show, status: :created, location: @habit }
      else
        format.html { render :new }
        format.json { render json: @habit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /habits/1
  # PATCH/PUT /habits/1.json
  def update
    respond_to do |format|
      if @habit.update(habit_params)
        format.html { redirect_to @habit, notice: 'Habit profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @habit }
      else
        format.html { render :edit }
        format.json { render json: @habit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /habits/1
  # DELETE /habits/1.json
  def destroy
    @habit.destroy
    respond_to do |format|
      format.html { redirect_to habits_url, notice: 'Habit profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def index_public
    @habits = Habit.where(is_public: true)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_habit
      @habit = Habit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def habit_params
      params.require(:habit).permit(:name, :description, :habit_type, :threshold, :unit, :min_or_max, :target_streak, :is_public, :frequency, :number_of_days)
    end

    def authorize_habit_crud!
      redirect_to root_path, alert: 'Access Denied' unless can? :crud, @habit
    end

    def authorize_habit_show!
      redirect_to root_path, alert: 'Access Denied' unless can? :show, @habit
    end

    def authorize_habit_destroy!
      redirect_to root_path, alert: 'Access Denied' unless can? :destroy, @habit
    end

end
