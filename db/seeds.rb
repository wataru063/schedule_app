categories = ["設備保全Tm","設備検査Tm","計装Tm","電気Tm","設計Tm",]

categories.each do |category|
  Category.create!(name: category)
end