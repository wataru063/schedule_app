module EventsHelper
  def create_event(id)
    events = []
    facility_id = id.present? ? id : 1
    oil_ids     = Facility.find(facility_id).oils.ids
    @constructions = Construction.where(facility_id: facility_id) +
                     Construction.where(facility_id: nil, oil_id: oil_ids)
    @orders = Order.where(facility_id: facility_id)
    n = 0
    @constructions.each do |c|
      n += 1
      event = {}
      duration = "#{c.start_at.strftime("%-m/%-d %-H:%M")}〜#{c.end_at.strftime("%-m/%-d %-H:%M")}"
      event.store(:id, c.id)
      event.store(:title, "【制約】#{duration} #{c.name}")
      event.store(:start, c.start_at)
      event.store(:end, c.end_at)
      #event.store(:url, "/#{current_user.id}/calendar/index")
      event.store(:display, "list-item")
      event.store(:color, "#ffff00")
      event.store(:textColor, "#000000")
      events << event
    end

    @orders.each do |o|
      n += 1
      event = {}
      shipment = o.shipment_id == 1 ? "入" : "出"
      title = "［#{shipment}］#{o.arrive_at.strftime("%-H:%M")} #{o.name}
                #{o.oil.name} #{o.quantity} #{o.unit} #{o.company_name}"
      event.store(:id, n)
      event.store(:title, title)
      event.store(:start, o.arrive_at)
      event.store(:end, "")
      event.store(:url, "/#{current_user.id}/orders/#{o.id}")
      event.store(:color, "#e4e3e3")
      event.store(:textColor, "#000000")
      events << event
    end
    events
  end
end
