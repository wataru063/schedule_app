class Status < ActiveHash::Base
  include ActiveHash::Associations
  has_many :constructions, class_name: "Construction"
  self.data = [{ id: 1, name: '実行検討中' }, { id: 2, name: '工事準備中' },
               { id: 3, name: '工事中' }, { id: 4, name: '工事完了' },]
end
