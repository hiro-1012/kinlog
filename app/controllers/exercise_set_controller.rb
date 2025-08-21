class ExerciseSetController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout
  before_action :authorize!

  def create
    @exercise_set = @workout.exercise_sets.build(exercise_set_params)
    if @exercise_set.save
      redirect_to @workout, notice: "セットを作成しました"
    else
      redirect_to @workout, alert: "セットの作成に失敗しました"
    end
  end

  def update
    @exercise_set = @workout.exercise_sets.find(params[:id])
    if @exercise_set.update(exercise_set_params)
      redirect_to @workout, notice: "セットを更新しました"
    else
      redirect_to @workout, alert: "セットの更新に失敗しました"
    end
  end

  def destroy
    @exercise_set = @workout.exercise_sets.find(params[:id])
    @exercise_set.destroy
    redirect_to @workout, notice: "セットを削除しました"
  end

  private
  def set_workout
    @workout = current_user.workouts.find(params[:workout_id])
  end

  def authorize!
    redirect_to @workout, alert: "記録を編集する権限がありません" unless @workout.user == current_user
  end

  def exercise_set_params
    params.require(:exercise_set).permit(:exercise_id, :reps, :weight, :note)
  end

end
