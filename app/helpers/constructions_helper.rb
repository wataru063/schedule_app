module ConstructionsHelper
require 'csv'
  def set_time(params, period)
    if params["#{period}_at_date"].present?
      count = 1
      period_date = params["#{period}_at_date"].split("-")
      period_date.each do |pd|
        params["#{period}_at(#{count}i)"] = pd
        count += 1
      end
    end
    params
  end

  # sort
  def sort_asc(column_to_be_sorted, search_params = nil)
    opts = { :column => column_to_be_sorted, :direction => "asc" }
    opts.merge!(search_params) if search_params.present?
    link_to "▲", opts
  end

  def sort_desc(column_to_be_sorted, search_params = nil)
    opts = { :column => column_to_be_sorted, :direction => "desc" }
    opts.merge!(search_params) if search_params.present?
    link_to "▼", opts
  end

  def sort_direction
    %W(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end

  # export to csv
  def to_csv(constructions)
    CSV.generate do |csv|
      columns_ja = %w(No. 工事名 現状況 特記事項 制約設備 制約油種 カテゴリー名 担当者名 工事開始日時 工事終了日時)
      columns = %w(no name status notice facility_name oil_name category_name user_name start_at end_at)
      csv << columns_ja
      no = 1
      constructions.each do |construction|
        con_attr = construction.attributes
        con_attr["no"] = no
        con_attr["oil_name"] = construction.oil.name
        con_attr["facility_name"] = construction.facility.name
        con_attr["category_name"] = construction.category.name
        con_attr["user_name"] = construction.user.name
        con_attr["start_at"] = construction.start_at.strftime("%Y年%m月%d日%H時%M分")
        con_attr["end_at"] = construction.end_at.strftime("%Y年%m月%d日%H時%M分")
        csv << con_attr.values_at(*columns)
        no += 1
      end
    end
  end
end
