require 'rails_helper'

RSpec.describe Oil, type: :model do
  let(:oil) { build(:oil) }

  it 'has a valid factory' do
    expect(oil).to be_valid
  end

  describe 'Association' do
    let(:association) do
       described_class.reflect_on_association(target)
    end

    context 'relate_to_facilities' do
      let(:target) { :relate_to_facilities }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'FacilityOil' }
    end

    context 'facilities' do
      let(:target) { :facilities }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Facility' }
    end

    context 'constructions' do
      let(:target) { :constructions }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Construction' }
    end

    context 'orders' do
      let(:target) { :orders }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Order' }
    end
  end

  describe 'name' do
    it 'is invalid without a name' do
      oil.name = ''
      oil.valid?
      expect(oil.errors[:name]).to include("を入力してください")
    end

    it "is invalid with a duplicate name" do
      duplicate_oil = build(:oil, name: oil.name)
      oil.save!
      duplicate_oil.valid?
      expect(duplicate_oil.errors[:name]).to include("はすでに存在します")
    end
  end
end
