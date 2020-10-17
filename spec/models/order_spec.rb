require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:facility) { create(:facility) }
  let(:order) { build(:order, facility_id: facility.id) }

  it 'has a valid factory' do
    expect(order).to be_valid
  end
  describe 'association' do
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

    context 'user' do
      let(:target) { :user }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context 'shipment' do
      let(:target) { :shipment }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Shipment' }
    end
  end

  describe 'name' do
    it 'is invalid without a name' do
      order.name = ''
      order.valid?
      expect(order.errors[:name]).to include("を入力してください")
    end
  end

  describe 'quantity' do
    it 'is invalid without a quantity' do
      order.quantity = ''
      order.valid?
      expect(order.errors[:quantity]).to include("を入力してください")
    end
  end

  describe 'shipment' do
    it 'is invalid without a shipment_id' do
      order.shipment_id = ''
      order.valid?
      expect(order.errors[:shipment_id]).to include("を入力してください")
    end
  end

  describe 'company_name' do
    it 'is invalid without a company_name' do
      order.company_name = ''
      order.valid?
      expect(order.errors[:company_name]).to include("を入力してください")
    end
  end

  describe 'facility_id' do
    it 'is invalid without a facility_id' do
      order.facility_id = ''
      order.valid?
      expect(order.errors[:facility_id]).to include("を入力してください")
    end
  end

  describe 'oil_id' do
    it 'is invalid without a oil_id' do
      order.oil_id = ''
      order.valid?
      expect(order.errors[:oil_id]).to include("を入力してください")
    end
  end

  describe 'user_id' do
    it 'is invalid without a user_id' do
      order.user_id = ''
      order.valid?
      expect(order.errors[:user_id]).to include("を入力してください")
    end
  end

  describe 'arrive_at' do
    before { order.valid? }

    context 'with nil' do
      let(:order) { build(:order, arrive_at: '') }

      it { expect(order.errors[:arrive_at]).to include("を入力してください") }
    end

    context 'in today or past' do
      let(:order) { build(:order, arrive_at: Time.current.end_of_day) }

      it { expect(order.errors[:arrive_at]).to include("は翌日以降に設定してください") }
    end

    context 'after tomorrow' do
      let(:order) { build(:order, arrive_at: Time.current.tomorrow.beginning_of_day) }

      it { expect(order).to be_valid }
    end

    context 'overlap with other orders' do
      let(:other_order) { build(:order, facility_id: order.facility_id, arrive_at: order.arrive_at) }

      it 'is invalid' do
        order.save
        other_order.valid?
        expect(other_order.errors[:arrive_at]).to include(
          "：#{other_order.facility.name}のこの時間には他のオーダーが入っています"
        )
      end
    end

    context 'during construction' do
      let(:construction) { create(:construction, facility_id: order.facility_id) }
      let(:test_order) do
        build(:order, facility_id: order.facility_id, arrive_at: construction.start_at + 1.day,
                      arrive_at_date: construction.start_at_date + 1.day)
      end

      it 'is invalid' do
        test_order.valid?
        expect(test_order.errors[:arrive_at]).to include(
          "：#{test_order.facility.name}のこの時間は工事(#{construction.name})による出荷制約があります"
        )
      end
    end
  end

  describe 'arrive_at_date' do
    it 'is invalid without a arrive_at_date' do
      order.arrive_at_date = ''
      order.valid?
      expect(order.errors[:arrive_at_date]).to include("を入力してください")
    end
  end

  describe 'unit' do
    it 'is invalid without a unit' do
      order.unit = ''
      order.valid?
      expect(order.errors[:unit]).to include("を入力してください")
    end
  end
end
