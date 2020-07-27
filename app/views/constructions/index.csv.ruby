require 'csv'
constructions = Construction.all.includes(:facility, :oil, :user, :category)
CSV.generate do |csv|
  columns_ja = %w(ID 工事名 現状況 特記事項 制約設備 制約油種 カテゴリー名 担当者名 工事開始日時 工事終了日時)
  columns = %w(id name status notice facility_name oil_name category_name user_name start_at end_at)
  csv << columns_ja
  constructions.each do |construction|
    con_attr = construction.attributes
    con_attr["oil_name"] = construction.oil.name
    con_attr["facility_name"] = construction.facility.name
    con_attr["category_name"] = construction.category.name
    con_attr["user_name"] = construction.user.name
    con_attr["start_at"] = construction.start_at.strftime("%Y年%m月%d日%H時%M分")
    con_attr["end_at"] = construction.end_at.strftime("%Y年%m月%d日%H時%M分")
    csv << con_attr.values_at(*columns)
  end
end
