# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ゲストユーザーを作成
guest_user = User.find_or_create_by!(email: 'guest@example.com') do |user|
  user.password = 'password123'
  user.name = 'ゲストユーザー'
end

# カテゴリとエクササイズのサンプルデータ
parts = {
  "胸"  => %w[ベンチプレス インクラインダンベルプレス ダンベルフライ],
  "背中" => %w[デッドリフト ラットプルダウン バーベルロウ],
  "脚"  => %w[スクワット レッグプレス ルーマニアンデッドリフト],
  "肩"  => %w[ショルダープレス サイドレイズ リアレイズ],
  "腕"  => %w[バーベルカール トライセプスプレスダウン],
  "体幹" => %w[プランク アブローラー]
}

parts.each do |cat, exs|
  c = Category.find_or_create_by!(name: cat)
  exs.each { |e| Exercise.find_or_create_by!(name: e, category: c) }
end

# ゲストユーザーのサンプルワークアウトを作成
if guest_user.workouts.empty?
  workout = guest_user.workouts.create!(
    performed_on: Date.current - 1.day
  )
  
  # サンプルのエクササイズセットを作成
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

puts "サンプルデータが作成されました！"
puts "ゲストユーザー: #{guest_user.email}"
puts "カテゴリ数: #{Category.count}"
puts "エクササイズ数: #{Exercise.count}"
puts "ワークアウト数: #{guest_user.workouts.count}"