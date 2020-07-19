# categories table setting
categories = ["設備保全Tm","設備検査Tm","計装Tm","電気Tm","設計Tm"]
categories.each do |category|
  Category.create!(name: category)
end

# oils table setting
oils = %w(ハイオク レギュラー ガソリン半製品 ライトナフサ 灯油 軽油 低硫黄A重油 A重油 C重油 ベンゼン キシレン プロピレン ブチレン・ブタン 低温プロパン 低温ブタン JET)
oils.each do |oil|
  Oil.create!(name: oil)
end

# users table setting
User.create!(name:  "test00",
             email: "test00@test00.com",
             password:              "test00",
             password_confirmation: "test00",
             category_id:1)
9.times do |n|
  name  = "test0#{n+1}"
  email = "test0#{n+1}@test0#{n+1}.com"
  password = "test0#{n+1}"
  category = rand(1..5)
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               category_id:           category)
end

# facilities table setting
facilities = %w(第一桟橋 第二桟橋 第三桟橋 第四桟橋 第五桟橋 第六桟橋 第七桟橋 共同桟橋 陸上出荷設備 タンク車出荷設備)
facilities.each do |facility|
  Facility.create!(name: facility)
end

# relationship between facilities and oils
facilities = Facility.all
n = 1
facilities.each do |facility|
  facility.relate(Oil.find_by(id: n))
  facility.relate(Oil.find_by(id: n+1))
  facility.relate(Oil.find_by(id: n+2))
  facility.relate(Oil.find_by(id: n+3))
  facility.relate(Oil.find_by(id: n+4))
  n += 1
end
