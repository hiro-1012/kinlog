# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
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