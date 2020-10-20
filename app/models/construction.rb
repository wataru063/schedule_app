class Construction < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  attr_accessor :start_at_date, :end_at_date
  has_many   :comments, class_name: "Comment", dependent: :destroy
  belongs_to :facility, class_name: "Facility", foreign_key: 'facility_id', optional: true
  belongs_to :oil, class_name: "Oil", foreign_key: 'oil_id', optional: true
  belongs_to :user, class_name: "User", foreign_key: 'user_id', optional: true
  belongs_to :status, class_name: "Status", foreign_key: 'status_id', optional: true
  validates :name,          presence: true
  validates :status_id,     presence: true
  validates :oil_id,        presence: true
  validates :user_id,       presence: true
  validates :start_at,      presence: true
  validates :end_at,        presence: true
  validates :start_at_date, presence: true
  validates :end_at_date,   presence: true
  # custom validation
  validate  :start_at_not_before_two_months_later, on: :create
  validate  :end_date_not_before_start_at_date
  # custom validation definition
  def start_at_not_before_two_months_later
    if start_at_date.present? && start_at.present? && start_at < Time.current.since(2.month)
      errors.add(:start_at, "は2ヶ月後以降に設定してください")
    end
  end

  def end_date_not_before_start_at_date
    if start_at.present? && end_at.present? && end_at_date.present? && end_at <= start_at
      errors.add(:end_at, "は工事開始日時より前に設定できません")
    end
  end

  # search
  def self.search(params)
    status_id = params[:status_id]
    facility_id = params[:facility_id]
    oil_id = params[:oil_id]
    start_at_date = params[:start_at_date]
    end_at_date = params[:end_at_date]
    if start_at_date.present?
      start_at = Date.new(params["start_at(1i)"].to_i, params["start_at(2i)"].to_i,
                          params["start_at(3i)"].to_i)
    end
    if end_at_date.present?
      end_at = Date.new(params["end_at(1i)"].to_i, params["end_at(2i)"].to_i,
                        params["end_at(3i)"].to_i)
    end
    @construction = Construction.all
    @construction = @construction.where(status_id: status_id) if status_id.present?
    @construction = @construction.where(facility_id: facility_id) if facility_id.present?
    @construction = @construction.where(oil_id: oil_id) if oil_id.present?
    @construction = @construction.where("start_at >= ?", start_at) if start_at.present?
    @construction = @construction.where("end_at <= ?", end_at) if end_at.present?
    @construction
  end
end
