class ApplicationController < ActionController::Base
  # Devise: ログイン後の遷移先
  def after_sign_in_path_for(resource)
    workouts_path
  end
end
