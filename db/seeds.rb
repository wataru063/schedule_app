# categories table setting
categories = ["設備保全Tm","設備検査Tm","計装Tm","電気Tm","設計Tm"]
categories.each do |category|
  Category.create!(name: category)
end

# oils table setting
oils = %w(ハイオク レギュラー 灯油 軽油 A重油 C重油 キシレン ガソリン半製品 ライトナフサ 低硫黄A重油 ベンゼン プロピレン ブチレン・ブタン 低温プロパン 低温ブタン JET)
oils.each do |oil|
  Oil.create!(name: oil)
end

# users table setting
#User.create!(name:  "example",
#             email: "example@example.com",
#             password:              "example",
#             password_confirmation: "example",
#             category_id:1)
#9.times do |n|
#  name  = "example#{n+2}"
#  email = "example#{n+2}@example#{n+2}.com"
#  password = "example#{n+2}"
#  category = rand(4)
#  User.create!(name:  name,
#               email: email,
#               password:              password,
#               password_confirmation: password,
#               category_id:           category)
#end

# facilities table setting
facilities = %w(第一桟橋 第二桟橋 第三桟橋 第四桟橋 第五桟橋 第六桟橋 第七桟橋 共同桟橋 陸上出荷設備 タンク車出荷設備)
facilities.each do |facility|
  Facility.create!(name: facility)
end
