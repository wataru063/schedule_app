class Comment < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: 'user_id'
  belongs_to :construction, class_name: "Construction", foreign_key: 'construction_id'
  validates :user_id, presence: true
  validates :construction_id, presence: true
  validates :content, presence: true
end
