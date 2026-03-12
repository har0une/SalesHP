class Goal < ApplicationRecord
  belongs_to :user
  has_many :sales_entries, dependent: :destroy

  scope :active, -> { where(active: true) }
end
