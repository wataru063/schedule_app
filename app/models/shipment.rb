class Shipment < ActiveHash::Base
  self.data = [{ id: 1, name: '入荷' }, { id: 2, name: '出荷' }]
end
