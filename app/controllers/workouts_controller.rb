class WorkoutsController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_workout, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @workouts = 
      if user_signed_in?
        current_user.workouts.order(performed_on: :desc).page(params[:page])
      else
        Workout.none
      end
  end

  def show
    @exercise_sets = @workout.exercise_sets.includes(:exercise, :category).page(params[:page])
    @exercise_set = @workout.exercise_sets.build
  end

  def new
    @workout = current_user.workouts.build(performed_on: Date.today)
  end

  def create
    @workout = current_user.workouts.build(workout_params)
    if @workout.save
      redirect_to @workout, notice: "記録を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @workout.update(workout_params)
      redirect_to @workout, notice: "記録を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workout.destroy
    redirect_to workouts_path, notice: "記録を削除しました"
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:id])
  end

  def authorize_user!
    unless @workout.user == current_user
      redirect_to workouts_path, alert: "記録を編集する権限がありません"
    end
  end

  def workout_params
    params.require(:workout).permit(:performed_on, :note)
  end
end
