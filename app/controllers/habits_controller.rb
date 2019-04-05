class HabitsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_habit, only: [:show, :edit, :update, :destroy]

  # GET /habits/new as new_habit_path [habits#new]
  def new
    @habit = Habit.new
  end

  # POST /habits as habits_path [habits#create]
  def create
    @habit = Habit.new(habit_params)
    @habit.user = current_user
    respond_to do |format|
      if @habit.save
        format.html { redirect_to @habit, notice: "Habit profile was successfully created" }
        format.json { render :show, status: :created, location: @habit }
      else
        format.html { render :new }
        format.json { render json: @habit.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /habits as habits_path [habits#index]
  def index
    @habits = Habit.all.order(created_at: :desc)
  end

  # GET /habits/:id as habit_path(id) [habits#show]
  def show
  end

  # DELETE /habits/:id as habit_path(id) [habits#destroy]
  def destroy
    @habit.destroy
    respond_to do |format|
      format.html { redirect_to habits_url, notice: "Habit was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  # GET /habits/:id/edit as edit_habit_path [habits#edit]
  def edit
  end

  # PATCH /habits/:id as habit_path(id) [habits#update]
  def update
    respond_to do |format|
      if @habit.update(habit_params)
        format.html { redirect_to @habit, notice: "Habit was successfully updated" }
        format.json { render :show, status: :ok, location: @habit }
      else
        format.html { render :edit }
        format.json { render json: @habit.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_habit
    @habit = Habit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def habit_params
    params.require(:habit).permit(:name, :description, :type, :threshold, :unit, :min_or_max, :target_streak, :is_public, :frequency, :number_of_days)
  end

end
