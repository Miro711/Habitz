class TackledHabitsController < ApplicationController
  before_action :set_tackled_habit, only: [:show, :edit, :update, :destroy]

  # GET /tackled_habits
  # GET /tackled_habits.json
  def index
    @tackled_habits = TackledHabit.all
  end

  # GET /tackled_habits/1
  # GET /tackled_habits/1.json
  def show
  end

  # GET /tackled_habits/new
  def new
    @tackled_habit = TackledHabit.new
  end

  # GET /tackled_habits/1/edit
  def edit
  end

  # POST /tackled_habits
  # POST /tackled_habits.json
  def create
    @tackled_habit = TackledHabit.new(tackled_habit_params)

    respond_to do |format|
      if @tackled_habit.save
        format.html { redirect_to @tackled_habit, notice: 'Tackled habit was successfully created.' }
        format.json { render :show, status: :created, location: @tackled_habit }
      else
        format.html { render :new }
        format.json { render json: @tackled_habit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tackled_habits/1
  # PATCH/PUT /tackled_habits/1.json
  def update
    respond_to do |format|
      if @tackled_habit.update(tackled_habit_params)
        format.html { redirect_to @tackled_habit, notice: 'Tackled habit was successfully updated.' }
        format.json { render :show, status: :ok, location: @tackled_habit }
      else
        format.html { render :edit }
        format.json { render json: @tackled_habit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tackled_habits/1
  # DELETE /tackled_habits/1.json
  def destroy
    @tackled_habit.destroy
    respond_to do |format|
      format.html { redirect_to tackled_habits_url, notice: 'Tackled habit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tackled_habit
      @tackled_habit = TackledHabit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tackled_habit_params
      params.require(:tackled_habit).permit(:user_id, :habit_id, :is_reminder, :current_streak, :maximum_streak, :number_of_attempts, :success_percent)
    end
end
