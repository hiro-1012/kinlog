# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # ゲストログイン
  def guest_sign_in
    user = User.guest
    
    # ゲストユーザーのデータをリセット（毎回クリーンな状態で開始）
    User.reset_guest_data
    
    sign_in user
    redirect_to workouts_path, notice: 'ゲストユーザーでログインしました。サンプルデータが表示されます。'
  end

  # ゲストユーザーのログアウト時
  def destroy
    if current_user&.guest?
      # ゲストユーザーの場合は、データをリセットしてからログアウト
      User.reset_guest_data
      redirect_to root_path, notice: 'ゲストユーザーをログアウトしました。データはリセットされました。'
    else
      super
    end
  end
end
