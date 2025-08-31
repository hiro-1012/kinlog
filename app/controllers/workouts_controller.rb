class WorkoutsController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_workout, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    # カレンダー用：対象月
    @current_month = begin
      params[:month].present? ? Date.parse(params[:month]) : Date.current
    rescue ArgumentError
      Date.current
    end
    @start_date = @current_month.beginning_of_month
    @end_date   = @current_month.end_of_month
    @calendar_start = @start_date.beginning_of_week(:sunday)
    @calendar_end   = @end_date.end_of_week(:sunday)

    # 記録日を色付けするための日別件数（当月のみ）
    @workouts_count_by_date = if user_signed_in?
      current_user.workouts
                   .where(performed_on: @start_date..@end_date)
                   .group(:performed_on)
                   .count
    else
      {}
    end

    # 一覧（当月分を新しい順）
    @workouts = if user_signed_in?
      current_user.workouts
                  .where(performed_on: @start_date..@end_date)
                  .order(performed_on: :desc)
    else
      Workout.none
    end
  end

  def show
    @exercise_sets = @workout.exercise_sets.includes(:exercise, :category).order(created_at: :asc)
    @exercise_set = @workout.exercise_sets.build

    # フォーム用データ
    @categories = Category.order(:name)
    @exercises  = Exercise.includes(:category).order('categories.name, exercises.name')
  end

  def new
    default_date = begin
      params[:date].present? ? Date.parse(params[:date]) : Date.today
    rescue ArgumentError
      Date.today
    end
    @workout = current_user.workouts.build(performed_on: default_date)
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
