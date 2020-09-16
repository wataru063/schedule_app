require 'rails_helper'

RSpec.describe Oil, type: :model do
  before do
    @oil = build(:test_oil)
  end

  it 'has a valid factory' do
    expect(@oil).to be_valid
  end

  describe 'name' do
    it 'is invalid without a name' do
      @oil.name = ''
      @oil.valid?
      expect(@oil.errors[:name]).to include("を入力してください")
    end

    it "is invalid with a duplicate name" do
      duplicate_oil = build(:oil, name: @oil.name)
      @oil.save!
      duplicate_oil.valid?
      expect(duplicate_oil.errors[:name]).to include("はすでに存在します")
    end
  end
end
