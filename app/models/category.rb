class Category < ApplicationRecord
  has_many :user_categories, foreign_key: "category_id"
  has_many :users, through: :user_categories
  validates :name, presence: true
end
