class ExerciseSet < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise
  
  validates :reps, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :weight, presence: true
end


