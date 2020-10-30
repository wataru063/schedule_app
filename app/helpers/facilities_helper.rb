module FacilitiesHelper
  # export to csv
  def to_csv_facility(facilities)
    CSV.generate do |csv|
      columns_ja = %w(No. 設備名 登録日時 更新日時)
      columns = %w(no name created_at updated_at)
      csv << columns_ja
      no = 1
      facilities.each do |f|
        con_attr = f.attributes
        con_attr["no"] = no
        con_attr["name"] = f.name
        con_attr["created_at"] = f.created_at.strftime("%Y年%m月%d日%H時%M分")
        con_attr["updated_at"] = f.updated_at.strftime("%Y年%m月%d日%H時%M分")
        csv << con_attr.values_at(*columns)
        no += 1
      end
    end
  end
end
