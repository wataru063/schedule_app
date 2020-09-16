require 'rails_helper'

RSpec.describe Facility, type: :model do
  before do
    @facility = build(:test_facility)
  end

  describe 'name' do
    it 'is invalid with blank words' do
      @facility.name = ''
      @facility.valid?
      expect(@facility.errors[:name]).to include("を入力してください")
    end

    context 'with 50 words or lower' do
      it 'is valid' do
        @facility.name = "a" * 50
        @facility.valid?
        expect(@facility).to be_valid
      end
    end

    context 'with more than 50 words' do
      it 'is invalid' do
        @facility.name = "a" * 51
        @facility.valid?
        expect(@facility.errors[:name]).to include("は50文字以内で入力してください")
      end
    end

    it "is invalid with a duplicate name address" do
      duplicate_facility = build(:facility, name: @facility.name)
      @facility.save!
      duplicate_facility.valid?
      expect(duplicate_facility.errors[:name]).to include("はすでに存在します")
    end
  end
end
