class Habit < ApplicationRecord
  
  belongs_to :user
  has_many :tackled_habits, dependent: :destroy

  before_validation(:set_default_frequency)
  before_validation(:set_default_number_of_days)

  validates :name, presence: true, uniqueness: true
  validates :habit_type, presence: true, inclusion: {in: ["binary","number"]}
  validates :threshold, numericality: { greater_than_or_equal_to: 0 }
  validates :min_or_max, inclusion: {in: %w(least most)}
  validates :target_streak, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :frequency, inclusion: {in: %w(daily weekly monthly yearly)}
  validates :number_of_days, numericality: { only_integer: true, greater_than: 0 }

  private 

  def set_default_frequency
    self.frequency ||= 'daily'
  end

  def set_default_number_of_days
    self.number_of_days ||= 1
  end

end
