module ConstructionsHelper
require 'csv'
  # export to csv
  def to_csv_construction(constructions)
    CSV.generate do |csv|
      columns_ja = %w(No. 工事名 現状況 特記事項 制約設備 制約油種 担当者名 工事開始日時 工事終了日時)
      columns = %w(no name status notice facility_name oil_name user_name start_at end_at)
      csv << columns_ja
      no = 1
      constructions.each do |c|
        con_attr = c.attributes
        con_attr["no"] = no
        con_attr["status"] = c.status.name
        con_attr["oil_name"] = c.oil.name
        if c.facility_id.present?
          con_attr["facility_name"] = c.facility.name
        else
          con_attr["facility_name"] = "―"
        end
        con_attr["user_name"] = c.user.name
        con_attr["start_at"] = c.start_at.strftime("%Y年%m月%d日%H時%M分")
        con_attr["end_at"] = c.end_at.strftime("%Y年%m月%d日%H時%M分")
        csv << con_attr.values_at(*columns)
        no += 1
      end
    end
  end

  def set_construction_times
    operate_params = params[:construction].present? ? params[:construction] : params
    reset_time(operate_params, :start)
    reset_time(operate_params, :end)
    set_time(operate_params, :start)
    set_time(operate_params, :end)
  end

  def set_constructions
    @status = Status.all
    @facility_id = Construction.order('facility_id ASC').select(:facility_id).distinct
    @oil_id = Construction.order('oil_id ASC').select(:oil_id).distinct
    @all_constructions = Construction.all
    @sort_column = params[:column].presence || 'start_at'
    if params[:controller] == "admin/constructions"
      @constructions = Construction.search(search_params)
      @count = @constructions.count
      @constructions = @constructions.order(@sort_column + ' ' + sort_direction).
        page(params[:page]).per(9)
    else
      @constructions = Construction.search(search_params).
        order(@sort_column + ' ' + sort_direction).page(params[:page]).per(7)
    end
    @search_params = search_params
  end

  def set_construction_select
    @status = Status.all
    @category = Category.all
    @all_facilities = Facility.all
    @all_oils = Oil.all
    @user = User.all
    @facility = params[:facility_id].present? ? params[:facility_id] : Facility.first.id
    @oils = Facility.find(@facility).oils
    @start_at_date = params[:date].present? ? params[:date] : Date.tomorrow
    @end_at_date = @start_at_date
    @start_at_date = get_date(@construction, "start") if @construction.present?
    @end_at_date = get_date(@construction, "end") if @construction.present?
  end
end
