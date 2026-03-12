class SalesEntry < ApplicationRecord
  belongs_to :goal
  # The 'touch: true' tells the Goal (and User) that things have changed
  belongs_to :goal, touch: true 
  
  enum :status, { active: 0, voided: 1 }

   scope :active, -> { where(status: :active) }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :method, presence: true
  validate :method_must_be_in_user_list
  validates :goal_id, presence: true

  before_create :calculate_and_assign_xp
  
  # THIS IS THE CRITICAL PART:
  after_commit :update_user_xp, on: [:create, :update]

  private

  def method_must_be_in_user_list
    return unless goal&.user
    unless goal.user.sales_methods.include?(method)
      errors.add(:method, "is not a valid sales channel for your profile")
    end
  end

  def calculate_and_assign_xp
    # The first method in the user's list is usually 'Direct' (1.0x)
    # Any other custom methods (Referral, Website, etc.) get the 1.5x bonus
    multiplier = (method == goal.user.sales_methods.first) ? 1.0 : 1.5
    self.xp_earned = (amount * 0.01 * multiplier).to_i
  end

  def update_user_xp
    # We find the owner of this sale
    user = goal.user
    # We sum up ONLY active sales
    total = user.goals.joins(:sales_entries).where(sales_entries: { status: :active }).sum(:xp_earned)
    # Update the user's XP and Rank
    user.update(total_xp: total)
    user.update_rank! # We will write this method next
  end
end


