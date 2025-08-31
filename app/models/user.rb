class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :workouts, dependent: :destroy

  # ゲストユーザーかどうかを判定
  def guest?
    email == 'guest@example.com'
  end

  # ゲストユーザーを作成または取得
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64(20)
      user.name = "ゲストユーザー"
    end
  end

  # ゲストユーザーのデータをリセット
  def self.reset_guest_data
    guest_user = find_by(email: 'guest@example.com')
    return unless guest_user
    
    # ゲストユーザーのワークアウトを削除
    guest_user.workouts.destroy_all
    
    # サンプルデータを再作成
    create_sample_workout_for_guest(guest_user)
  end

  private

  def self.create_sample_workout_for_guest(user)
    # サンプルのワークアウトを作成
    workout = user.workouts.create!(
      performed_on: Date.current - 1.day
    )
    
    # ベンチプレスのサンプルセットを作成
    chest_exercise = Exercise.find_by(name: 'ベンチプレス')
    if chest_exercise
      workout.exercise_sets.create!(
        exercise: chest_exercise,
        weight: 60.0,
        reps: 10,
        note: 'ゲストユーザーのサンプル記録'
      )
    end
  end
end
