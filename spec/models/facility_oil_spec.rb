require 'rails_helper'

RSpec.describe FacilityOil, type: :model do
  let(:facility) { create(:facility) }
  let(:oil)      { create(:oil) }
  let(:facility_oil) { build(:facility_oil, facility_id: facility.id, oil_id: oil.id) }

  describe 'factory' do
    it { expect(facility_oil.valid?).to be_truthy }
  end

  describe 'Association' do
    let(:association) do
       described_class.reflect_on_association(target)
    end

    context 'facility' do
      let(:target) { :facility }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Facility' }
    end

    context 'oil' do
      let(:target) { :oil }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Oil' }
    end
  end

  describe 'validation' do
    context 'with blank facility_id' do
      it 'is invalid' do
        facility_oil.facility_id = ''
        facility_oil.valid?
        expect(facility_oil.errors[:facility]).to include("を入力してください")
      end
    end

    context 'with blank oil_id' do
      it 'is invalid' do
        facility_oil.oil_id = ''
        facility_oil.valid?
        expect(facility_oil.errors[:oil_id]).to include("を入力してください")
      end
    end

    context 'with a duplicate combination of facility and oil' do
      let!(:duplicate) { build(:facility_oil, facility_id: facility.id, oil_id: oil.id) }

      it "is invalid" do
        facility_oil.save!
        duplicate.valid?
        expect(duplicate.errors[:facility_id]).to include("はすでに存在します")
      end
    end
  end
end
