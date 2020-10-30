class Admin::ConstructionsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :set_construction,  only: [:show, :edit, :update, :destroy]
  before_action :set_constructions, only: [:index, :search, :create, :edit, :update, :destroy]
  before_action :set_construction_select, only: [:new, :create, :edit, :update]

  def index
    admin_respond_to_html_js
  end

  def search
    respond_to do |format|
      format.js
      format.html do
        if search_params.present?
          csv = Construction.search(search_params).order(@sort_column + ' ' + sort_direction)
          send_data to_csv_construction(csv), filename: "#{Time.current.strftime('%Y%m%d')}工事一覧.csv"
        else
          redirect_to admin_top_url
        end
      end
    end
  end

  def new
    @construction = Construction.new
    admin_respond_to_html_js
  end

  def create
    @construction = Construction.new(construction_params)
    @success = @construction.save(context: :admin) ? true : false
  end

  def show
    @comment = Comment.new
    admin_respond_to_html_js
  end

  def edit
    admin_respond_to_html_js
  end

  def update
    @success = @construction.update_attributes(construction_params) ? true : false
  end

  def destroy
    @construction.destroy
    @count = Construction.search(search_params).count
  end

  private

  def set_construction
    @construction = Construction.find(params[:id])
  end

  def construction_params
    params.require(:construction).
      permit(:id, :name, :status_id, :notice, :facility_id, :oil_id, :user_id,
             :start_at, :end_at, :start_at_date, :end_at_date)
  end

  def search_params
    params.permit(:id, :name, :status_id, :notice, :facility_id, :oil_id, :user_id,
                  :start_at, :end_at, :start_at_date, :end_at_date)
  end
end
