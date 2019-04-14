class TackledHabit < ApplicationRecord
  
  belongs_to :user
  belongs_to :habit

  before_validation(:set_default_current_streak)
  before_validation(:set_default_wins)
  # before_validation(:set_default_maximum_streak)
  # before_validation(:set_default_number_of_attempts)
  # before_validation(:set_default_success_percent)

  validates :current_streak, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :wins, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # validates :maximum_streak, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # validates :number_of_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # validates :success_percent, numericality: { greater_than_or_equal_to: 0 }

  private

  def set_default_current_streak
    self.current_streak ||= 0
  end

  def set_default_wins
    self.wins ||= 0
  end

  # def set_default_maximum_streak
  #   self.maximum_streak ||= 0
  # end

  # def set_default_number_of_attempts
  #   self.number_of_attempts ||= 0
  # end

  # def set_default_success_percent
  #   self.success_percent ||= 0
  # end

end
