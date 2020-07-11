class FacilityOil < ApplicationRecord
  belongs_to :facility, class_name: "Facility"
  belongs_to :oil, class_name: "Oil"
end
