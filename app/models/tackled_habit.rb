class TackledHabit < ApplicationRecord
    belongs_to :user
    belongs_to :habits

    validates :current_streak, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :maximum_streak, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :number_of_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :success_percent, numericality: { greater_than_or_equal_to: 0 }
end
