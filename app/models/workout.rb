class Workout < ApplicationRecord
  belongs_to :user
  has_many :exercise_sets, dependent: :destroy
  validates :performed_on, presence: true

  def total_volume
    exercise_sets.sum("COALESCE(weight, 0) * COALESCE(reps, 0)")
  end
  
end
