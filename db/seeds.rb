# categories
categories = ["設備保全Tm","設備検査Tm","計装Tm","電気Tm","設計Tm"]
categories.each do |category|
  Category.create!(name: category)
end

# oils
oils = %w(ハイオク レギュラー ガソリン半製品 ライトナフサ 灯油 軽油 低硫黄A重油 A重油 C重油 ベンゼン キシレン プロピレン ブチレン・ブタン 低温プロパン 低温ブタン JET)
oils.each do |oil|
  Oil.create!(name: oil)
end

# users
User.create!(name:  "マスター",
             email: "master@master.com",
             password:              "master",
             password_confirmation: "master",
             category_id:1)
29.times do |n|
  name  = Faker::Name.name
  email = "test0#{n+1}@test0#{n+1}.com"
  password = "test0#{n+1}"
  category = rand(1..5)
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               category_id:           category)
end

# facilities
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

# construction
notices = ["工程内で制約日程は調整可能", "工事中は桟橋クローズ", "足場組立て期間のみ桟橋クローズ", "", ""]
100.times do |n|
  m  = rand(1..8)
  mm = rand(2..8)
  start_at = Time.now.since(mm.month + mm.days)
  end_at   = start_at.since(mm.days)
  user     = User.find(rand(1..29))
  status = m < 3 ? "工事準備中" : "実行検討中"
  notice = notices[rand(0..2)] if m > 4
  facility = Facility.find(rand(1..Facility.count-1))
  oil = facility.oils[rand(1..facility.oils.count-1)]
  facility_id = facility.id
  oil_id = oil.id
  user_id = user.id
  category_id = user.category_id
  if m % 2 == 0
    name = "#{facility.name}#{oil.name}配管補修工事"
  else
    name = "タンクヤード内#{oil.name}配管補修工事"
  end
  construction = Construction.create!(name: name,
                                      status: status,
                                      facility_id: facility_id,
                                      oil_id: oil_id,
                                      user_id: user_id,
                                      category_id: category_id,
                                      start_at: start_at,
                                      end_at: end_at,
                                      start_at_date: start_at,
                                      end_at_date: end_at,
                                      notice: notice
                                     )
  if n % 4 == 0
    start_at = Time.now.ago(1.days)
    end_at   = start_at.since(mm.days)
    construction.update_attribute(:start_at, start_at)
    construction.update_attribute(:end_at, end_at)
    construction.update_attribute(:status, "工事中")
  elsif n % 3 == 0
    start_at = Time.now.ago(10.days)
    end_at   = start_at.since(mm.days)
    construction.update_attribute(:start_at, start_at)
    construction.update_attribute(:end_at, end_at)
    construction.update_attribute(:status, "工事完了")
  end
end