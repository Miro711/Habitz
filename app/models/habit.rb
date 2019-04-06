class Habit < ApplicationRecord
  
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :habit_type, presence: true, inclusion: {in: ["binary","number"]}
  validates :threshold, numericality: { greater_than_or_equal_to: 0 }
  validates :min_or_max, inclusion: {in: %w(least most)}
  validates :target_streak, presence: true, numericality: { only_integer: true, greater_than: 0 }
  # validates :frequency, inclusion: {in: %w(daily weekly monthly yearly)}
  # validates :number_of_days, numericality: { only_integer: true, greater_than: 0 }

end
