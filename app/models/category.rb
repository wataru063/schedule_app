class Category < ApplicationRecord
  has_many :users, class_name: "User"
  has_many :constructions, class_name: "Construction"
  validates :name, presence: true
end
