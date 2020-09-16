require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = build(:test_comment)
  end

  describe 'construction_id' do
    it 'is invalid without a construction_id' do
      @comment.construction_id = ''
      @comment.valid?
      expect(@comment.errors[:construction_id]).to include("を入力してください")
    end
  end

  describe 'user_id' do
    it 'is invalid without a user_id' do
      @comment.user_id = ''
      @comment.valid?
      expect(@comment.errors[:user_id]).to include("を入力してください")
    end
  end

  describe 'content' do
    it 'is invalid without a content' do
      @comment.content = ''
      @comment.valid?
      expect(@comment.errors[:content]).to include("を入力してください")
    end
  end
end
