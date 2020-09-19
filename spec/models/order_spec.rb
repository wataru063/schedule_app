require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:facility) { create(:facility) }
  let(:order) { build(:order, facility_id: facility.id) }

  it 'has a valid factory' do
    expect(order).to be_valid
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
    it 'is invalid without a arrive_at' do
      order.arrive_at = ''
      order.valid?
      expect(order.errors[:arrive_at]).to include("を入力してください")
    end

    context 'in today or past' do
      it 'is invalid' do
        order.arrive_at = Time.current.end_of_day
        order.valid?
        expect(order.errors[:arrive_at]).to include("は翌日以降に設定してください")
      end
    end

    context 'after tomorrow' do
      it 'is valid' do
        order.arrive_at = Time.current.tomorrow.beginning_of_day
        expect(order).to be_valid
      end
    end

    it 'is invalid with a duplicate arrival time' do
      duplicate_order = order
      order.save
      duplicate_order.valid?
      expect(duplicate_order.errors[:arrive_at]).to include(
        "：#{duplicate_order.facility.name}のこの時間には他のオーダーが入っています"
      )
    end

    context 'during construction' do
      let(:construction) { build(:construction, facility_id: order.facility_id) }

      it 'is invalid' do
        order.arrive_at = construction.start_at + 1.day
        order.arrive_at_date = construction.start_at_date + 1.day
        construction.save
        order.valid?
        expect(order.errors[:arrive_at]).to include(
          "：#{order.facility.name}のこの時間は工事(#{construction.name})による出荷制約があります"
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
