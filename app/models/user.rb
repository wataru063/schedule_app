class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  attr_accessor :remember_token
  has_many   :constructions, class_name: "Construction"
  has_many   :orders, class_name: "Order"
  has_many   :comments, class_name: "Comment", dependent: :destroy
  belongs_to :category, class_name: "Category", foreign_key: 'category_id'
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX, allow_blank: true },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :category_id, presence: true

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

  # search
  def self.search(params)
    name = "%#{params[:name]}%"
    category_id = params[:category_id]
    @user = User.all
    @user = @user.where("name LIKE ?", name) if name.present?
    @user = @user.where(category_id: category_id) if category_id.present?
    @user
  end
end
