class Category < ActiveHash::Base
  include ActiveHash::Associations
  has_many :users, class_name: "User"
  has_many :facility, class_name: "Facility"
  self.data = [
    { id: 1, name: '設備保全Tm' }, { id: 2, name: '設備検査Tm' }, { id: 3, name: '計装Tm' },
    { id: 4, name: '電気Tm' }, { id: 5, name: '設計Tm' }, { id: 6, name: '需給管理Tm' },
  ]
end
