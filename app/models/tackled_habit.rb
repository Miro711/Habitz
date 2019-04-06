class TackledHabit < ApplicationRecord
  
  belongs_to :user
  belongs_to :habit

  validates :current_streak, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :maximum_streak, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :number_of_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :success_percent, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation(:set_default_current_streak)
  before_validation(:set_default_maximum_streak)
  before_validation(:set_default_number_of_attempts)
  before_validation(:set_default_success_percent)


  private

  def set_default_current_streak
    self.current_streak ||= 0
  end

  def set_default_maximum_streak
    self.maximum_streak ||= 0
  end

  def set_default_number_of_attempts
    self.number_of_attempts ||= 0
  end

  def set_default_success_percent
    self.success_percent ||= 0
  end

end
