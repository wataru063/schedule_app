class Admin::FacilitiesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :set_facility, only: [:show, :edit, :update, :destroy, :related_oil_destroy]
  before_action :set_facilities, except: [:show]
  before_action :set_facility_select, only: [:new, :create, :edit, :update]

  def index; end

  def search
    respond_to do |format|
      format.js
      format.html do
        if search_params.present?
          csv = Facility.search(search_params).order(@sort_column + ' ' + sort_direction)
          send_data to_csv_facility(csv), filename: "#{Time.current.strftime('%Y%m%d')}荷役設備一覧.csv"
        else
          redirect_to admin_top_url
        end
      end
    end
  end

  def new
    @facility = Facility.new
    @facility.relate_to_oils.build
    admin_respond_to_html_js
  end

  def create
    @facility = Facility.new(facility_params)
    ActiveRecord::Base.transaction do
      @facility.save!
      params[:facility][:oil_id].each { |p| @facility.relate_to_oils.create!(oil_id: p.to_i) }
      @success = true
    end
  rescue ActiveRecord::RecordInvalid
    @success = false
    @count = Facility.search(search_params).count
    admin_respond_to_html_js
  end

  def show
    oil_ids = []
    @facility.oils.each do |oil|
      oil_ids << oil.id
    end
    if oil_ids.present?
      oil_ids = oil_ids.uniq.sort! { |a, b| a.to_i <=> b.to_i }
      @oils = Oil.where(id: oil_ids).page(params[:page]).per(5)
    end
  end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @facility.update_attributes!(facility_params)
      params[:facility][:oil_id].each { |idx, o| @facility.relate_to_oils.create!(oil_id: o.to_i) }
      @success = true
      @all_oils = Oil.where.not(id: @facility.oils.ids)
      @oil_selects = @all_oils.pluck(:id, :name).to_h.to_json
    end
  rescue ActiveRecord::RecordInvalid
    @success = false
    @count = Facility.search(search_params).count
    @all_oils = Oil.where.not(id: @facility.oils.ids)
    @oil_selects = @all_oils.pluck(:id, :name).to_h.to_json
    admin_respond_to_html_js
  end

  def destroy
    @facility.destroy
    @count = Facility.search(search_params).count
  end

  def related_oil_destroy
    @oil = @facility.relate_to_oils.find_by(oil_id: params[:oil_id])
    @orders = Order.where(facility_id: @facility.id, oil_id: @oil.id)
    @constructions = Construction.where(facility_id: @facility.id, oil_id: @oil.id)
    @oil.destroy
    @orders.destroy_all
    @constructions.destroy_all
    set_facility_select
  end

  private

    def set_facility
      @facility = Facility.find(params[:id])
    end

    def facility_params
      params.
        require(:facility).permit(:name)
    end

    def search_params
      params.permit(:name, :created_at, :updated_at, :created_at_date, :updated_at_date)
    end

    def set_facilities
      reset_time(params, :created)
      reset_time(params, :updated)
      set_time(params, :created)
      set_time(params, :updated)
      @all_facilities = Facility.all
      @facilities = Facility.search(search_params)
      @count = @facilities.count
      @sort_column = params[:column].presence || 'created_at'
      @facilities = @facilities.order(@sort_column + ' ' + sort_direction).
        page(params[:page]).per(13)
      @search_params = search_params
    end

    def set_facility_select
      @oils = @facility.oils if @facility.present?
      @select_count = params[:select_count]
      @all_oils = @facility.blank? ? Oil.all : Oil.where.not(id: @facility.oils.ids)
      @oil_selects = @all_oils.pluck(:id, :name).to_h.to_json
      @add_oils = @facility.blank? ? Oil.where(id: 1..2) : Oil.where(id: 1)
    end
end
