module EventsHelper
  def create_event(id, current_user)
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
      # event.store(:url, "/constructions/#{c.id}")
      event.store(:display, "list-item")
      event.store(:color, "#ffff00")
      event.store(:textColor, "#000000")
      event.store(:flag, 0)
      events << event
    end

    if current_user.category_id == 6
      @orders.each do |o|
        n += 1
        event = {}
        shipment = o.shipment_id == 1 ? "入" : "出"
        title = "［#{shipment}］#{o.arrive_at.strftime("%-H:%M")} #{o.name}
                  #{o.oil.name} #{o.quantity} #{o.unit} #{o.company_name}"
        event.store(:id, o.id)
        event.store(:title, title)
        event.store(:start, o.arrive_at)
        event.store(:end, "")
        # event.store(:url, "/orders/#{o.id}")
        event.store(:color, "#e4e3e3")
        event.store(:textColor, "#000000")
        event.store(:flag, 1)
        events << event
      end
    end

    events
  end
end
