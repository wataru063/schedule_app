class UserCategory < ApplicationRecord
  belongs_to :user
  belongs_to :category
  validates  :user_id, presence: true, uniqueness: true
  validates  :category_id, presence: true
end
