require 'rails_helper'

RSpec.describe Construction, type: :model do
  before do
    @construction = build(:test_construction)
  end

  it 'has a valid factory' do
    expect(@construction).to be_valid
  end

  describe 'name' do
    it 'is invalid without a name' do
      @construction.name = ''
      @construction.valid?
      expect(@construction.errors[:name]).to include("を入力してください")
    end
  end

  describe 'status' do
    it 'is invalid without a status' do
      @construction.status = ''
      @construction.valid?
      expect(@construction.errors[:status]).to include("を入力してください")
    end
  end

  describe 'oil_id' do
    it 'is invalid without a oil_id' do
      @construction.oil_id = ''
      @construction.valid?
      expect(@construction.errors[:oil_id]).to include("を入力してください")
    end
  end

  describe 'user_id' do
    it 'is invalid without a user_id' do
      @construction.user_id = ''
      @construction.valid?
      expect(@construction.errors[:user_id]).to include("を入力してください")
    end
  end

  describe 'start_at' do
    it 'is invalid without a start_at' do
      @construction.start_at = ''
      @construction.valid?
      expect(@construction.errors[:start_at]).to include("を入力してください")
    end

    context 'within 2 months' do
      it 'is invalid' do
        @construction.start_at = Time.current + 2.month
        @construction.valid?
        expect(@construction.errors[:start_at]).to include("は2ヶ月後以降に設定してください")
      end
    end

    context 'after 2 months' do
      it 'is valid' do
        @construction.start_at = Time.current + 2.month + 1.day
        expect(@construction).to be_valid
      end
    end
  end

  describe 'start_at_date' do
    it 'is invalid without a start_at_date' do
      @construction.start_at_date = ''
      @construction.valid?
      expect(@construction.errors[:start_at_date]).to include("を入力してください")
    end
  end

  describe 'end_at' do
    it 'is invalid without a end_at' do
      @construction.end_at = ''
      @construction.valid?
      expect(@construction.errors[:end_at]).to include("を入力してください")
    end

    context 'before start_at' do
      it 'is invalid' do
        @construction.end_at = @construction.start_at
        @construction.valid?
        expect(@construction.errors[:end_at]).to include("は工事開始日時より前に設定できません")
      end
    end

    context 'after start_at' do
      it 'is valid' do
        @construction.end_at = @construction.start_at + 1.second
        expect(@construction).to be_valid
      end
    end
  end

  describe 'end_at_date' do
    it 'is invalid without a end_at_date' do
      @construction.end_at_date = ''
      @construction.valid?
      expect(@construction.errors[:end_at_date]).to include("を入力してください")
    end
  end

  describe 'category_id' do
    it 'is invalid without a category_id' do
      @construction.category_id = ''
      @construction.valid?
      expect(@construction.errors[:category_id]).to include("を入力してください")
    end
  end
end
