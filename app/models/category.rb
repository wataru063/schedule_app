class Category < ApplicationRecord
  has_many :user, class_name: "User"
  validates :name, presence: true
end
