require 'rails_helper'

RSpec.describe FacilityOil, type: :model do
  before do
    @facility_oil = build(:test_facility_oil)
  end

  describe 'facility_id' do
    it 'is invalid with blank words' do
      @facility_oil.facility_id = ''
      @facility_oil.valid?
      expect(@facility_oil.errors[:facility]).to include("を入力してください")
    end
  end

  describe 'oil_id' do
    it 'is invalid with blank words' do
      @facility_oil.oil_id = ''
      @facility_oil.valid?
      expect(@facility_oil.errors[:oil_id]).to include("を入力してください")
    end
  end

  it "is invalid with a duplicate combination of facility_id and oil_id" do
    duplicate_facility_oil = build(:test_facility_oil)
    @facility_oil.save!
    expect(duplicate_facility_oil).to be_invalid
  end
end
