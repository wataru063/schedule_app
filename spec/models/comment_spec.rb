require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { build(:test_comment) }

  describe 'Association' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'user' do
      let(:target) { :user }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context 'construction' do
      let(:target) { :construction }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Construction' }
    end
  end

  describe 'validation' do
    subject { comment.valid? }

    context 'construction_id' do
      before { comment.construction_id = '' }

      it 'is invalid without a construction_id' do
        subject
        expect(comment.errors[:construction_id]).to include("を入力してください")
      end
    end

    context 'user_id' do
      before { comment.user_id = '' }

      it 'is invalid without a user_id' do
        subject
        expect(comment.errors[:user_id]).to include("を入力してください")
      end
    end

    context 'content' do
      before { comment.content = '' }

      it 'is invalid without a content' do
        subject
        expect(comment.errors[:content]).to include("を入力してください")
      end
    end
  end
end
