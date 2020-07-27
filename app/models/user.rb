class User < ApplicationRecord
  attr_accessor :remember_token
  has_many :constructions, class_name: "Construction"
  belongs_to :category, class_name: "Category"
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX, allow_blank: true },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6, allow_blank: true }

  def User.digest(string)
    if ActiveModel::SecurePassword.min_cost
      cost = BCrypt::Engine::MIN_COST
    else
      cost = BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def store_in_db
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def remove_from_db
    update_attribute(:remember_digest, nil)
  end

  def add_category(category)
    categories << category
  end

  def remove_category(current_category)
    user_categories.find_by(category_id: current_category.id).destroy
  end

  def category?(category)
    categories.include?(category)
  end
end
