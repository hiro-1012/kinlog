class ExerciseSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout
  before_action :authorize!

  def new
    if params[:category_id].present?
      # 部位選択から来た場合：種目一覧を表示
      @category = Category.find(params[:category_id])
      @exercises = @category.exercises.order(:name)
      render :select_exercise
    elsif params[:exercise_id].present?
      # 種目選択から来た場合：セット記録フォームを表示
      @exercise = Exercise.find(params[:exercise_id])
      # 既存のセットを取得、なければ空の配列
      @exercise_sets = @workout.exercise_sets.where(exercise: @exercise).order(:created_at)
      # 最低3セット分のフォーム用オブジェクトを準備
      @exercise_sets = @exercise_sets.presence || Array.new(3) { @workout.exercise_sets.build(exercise: @exercise) }

      # 前回の同種目の合計ボリューム（直近の別日ワークアウト）
      previous_workout = current_user.workouts
                                    .where("performed_on < ?", @workout.performed_on)
                                    .joins(:exercise_sets)
                                    .where(exercise_sets: { exercise_id: @exercise.id })
                                    .order(performed_on: :desc)
                                    .distinct
                                    .first
      if previous_workout
        @previous_total_volume = previous_workout.exercise_sets
                                                .where(exercise: @exercise)
                                                .sum("weight * reps").to_i
      else
        @previous_total_volume = nil
      end
      render :edit
    else
      # 何も指定がない場合：部位選択画面を表示
      @categories = Category.order(:name)
      render :select_category
    end
  end

  def create
    # 複数セットを一括作成
    @exercise = Exercise.find(params[:exercise_id])
    success_count = 0
    error_messages = []
    
    # パラメータを許可してから処理
    exercise_sets_params = params.require(:exercise_sets).permit!
    
    exercise_sets_params.each do |key, set_params|
      next if set_params[:weight].blank? && set_params[:reps].blank?
      
      exercise_set = @workout.exercise_sets.build(
        exercise: @exercise,
        weight: set_params[:weight],
        reps: set_params[:reps],
        note: set_params[:note]
      )
      
      if exercise_set.save
        success_count += 1
      else
        error_messages << "セット#{key.to_i + 1}: #{exercise_set.errors.full_messages.join(', ')}"
      end
    end
    
    if success_count > 0
      redirect_to @workout, notice: "#{success_count}セットを作成しました"
    else
      redirect_to new_workout_exercise_set_path(@workout, exercise_id: @exercise.id), 
                  alert: "セットの作成に失敗しました: #{error_messages.join('; ')}"
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
