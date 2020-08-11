# categories
categories = ["設備保全Tm","設備検査Tm","計装Tm","電気Tm","設計Tm"]
categories.each do |category|
  Category.create!(name: category)
end

# oils
oils = %w(原油 ガソリン ガソリン半製品 ライトナフサ 灯油 軽油 低硫黄A重油 A重油 C重油 プロピレン ベンゼン キシレン ブチレン・ブタン 低温プロパン 低温ブタン JET)
oils.each do |oil|
  Oil.create!(name: oil)
end

# users
User.create!(name:  "マスター",
             email: "master@master.com",
             password:              "master",
             password_confirmation: "master",
             category_id:1)
19.times do |n|
  name  = Faker::Name.name
  email = Faker::Internet.email
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
30.times do |n|
  m  = rand(1..8)
  mm = rand(2..8)
  d  = rand(1..8)
  h  = rand(8..16)
  dh = rand(0..3)
  start_at = Time.now.midnight.since(mm.month + d.days + h.hour)
  end_at   = start_at.since(d.days + dh.hour)
  user     = User.find(rand(1..19))
  status = m < 3 ? 1 : 2
  notice = notices[rand(0..2)] if m > 4
  facility = Facility.find(rand(1..Facility.count-1))
  oil = facility.oils[rand(0..facility.oils.count-1)]
  oil_id = oil.id
  user_id = user.id
  category_id = user.category_id
  if n % 2 == 0
    name = "#{facility.name} #{oil.name} 配管補修工事"
    facility_id = facility.id
  else
    name = "タンクヤード内 #{oil.name} 配管補修工事"
    facility_id = ""
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
                                      notice: notice)
  if n % 6 == 0
    start_at = Time.now.midnight.ago(rand(1..4).days + h.hour)
    end_at   = start_at.since(d.days + dh.hour)
    construction.update_attribute(:start_at, start_at)
    construction.update_attribute(:end_at, end_at)
    if end_at < Time.now
      construction.update_attribute(:status, 4)
    else
      construction.update_attribute(:status, 3)
    end
  elsif  n % 5 == 0
    start_at = Time.now.midnight.since(rand(1..30).days + h.hour)
    end_at   = start_at.since(d.days + dh.hour)
    construction.update_attribute(:start_at, start_at)
    construction.update_attribute(:end_at, end_at)
    construction.update_attribute(:status, 2)
  end
end

#order
150.times do |n|
  m  = rand(1..60)
  d  = rand(1..20)
  h  = rand(9..15)
  arrive_at = Time.now.midnight.since(n.days + h.hour)
  user     = User.find(rand(1..19))
  facility = Facility.find(rand(1..Facility.count-1))
  oil = facility.oils[rand(0..facility.oils.count-1)]
  facility_id = facility.id
  oil_id = oil.id
  shipment = rand(1..100) % 2 == 0 && oil_id != 1 ? 1 : 2
  quantity = m * 100
  user_id = user.id

  if oil_id == 11 || oil_id == 12 || oil_id == 14 || oil_id == 15
    unit = "t"
  else
    unit = "kL"
  end

  if oil_id == 1
    company_name = Faker::Lorem.word + " " + Faker::Lorem.word
    name = Faker::Lorem.word + " " + Faker::Lorem.word
  elsif m % 3 == 0
    state_name = Faker::Address.state
    company_name = state_name + "事業所"
    name = state_name + "丸"
  else
    name = Faker::Name.last_name + Faker::Company.category
    name = Faker::Address.state + "丸"
  end
  order_1 = Order.new(name: name,
                       shipment: shipment,
                       company_name: company_name,
                       quantity: quantity,
                       unit: unit,
                       facility_id: facility_id,
                       oil_id: oil_id,
                       user_id: user_id,
                       arrive_at: arrive_at,
                       arrive_at_date: arrive_at)
  if order_1.save
  else
  end

  m  = rand(1..60)
  d  = rand(1..20)
  h  = rand(9..15)
  arrive_at = Time.now.midnight.since(n.days + h.hour)
  user     = User.find(rand(1..19))
  facility = Facility.find(rand(1..Facility.count-1))
  oil = facility.oils[rand(0..facility.oils.count-1)]
  facility_id = facility.id
  oil_id = oil.id
  shipment = rand(1..100) % 2 == 0 && oil_id != 1 ? 1 : 2
  quantity = m * 100
  user_id = user.id

  if oil_id == 11 || oil_id == 12 || oil_id == 14 || oil_id == 15
    unit = "t"
  else
    unit = "kL"
  end

  if oil_id == 1
    company_name = Faker::Lorem.word + " " + Faker::Lorem.word
    name = Faker::Lorem.word + " " + Faker::Lorem.word
  elsif m % 3 == 0
    state_name = Faker::Address.state
    company_name = state_name + "事業所"
    name = state_name + "丸"
  else
    company_name = Faker::Name.last_name + Faker::Company.category
    name = Faker::Address.state + "丸"
  end
  order_2 = Order.new(name: name,
                       shipment: shipment,
                       company_name: company_name,
                       quantity: quantity,
                       unit: unit,
                       facility_id: facility_id,
                       oil_id: oil_id,
                       user_id: user_id,
                       arrive_at: arrive_at,
                       arrive_at_date: arrive_at)
  if order_2.save
  else
  end
end
