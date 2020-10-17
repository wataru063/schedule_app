require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    let(:user) { build(:user) }

    it { expect(user).to be_valid }
  end

  describe 'association' do
    let(:association) do
       described_class.reflect_on_association(target)
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

    context 'comments' do
      let(:target) { :comments }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Comment' }
    end

    context 'category' do
      let(:target) { :category }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Category' }
    end
  end

  describe 'name' do
    let(:user) { build(:user, name: name) }

    before { user.valid? }

    context 'without a name' do
      let(:name) { '' }

      it { expect(user.errors[:name]).to include("を入力してください") }
    end

    context 'with 50 words or lower' do
      let(:name) { "a" * 50 }

      it { expect(user).to be_valid }
    end

    context 'with more than 50 words' do
      let(:name) { "a" * 51 }

      it { expect(user.errors[:name]).to include("は50文字以内で入力してください") }
    end
  end

  describe 'email' do
    let(:user) { build(:user, email: email) }

      before { user.valid? }

    context 'with blank words' do
      let(:email) { '' }

      it { expect(user.errors[:email]).to include("を入力してください") }
    end

    context 'with 255 words or lower' do
      let(:email) { "a" * 243 + "@example.com" }

      it { expect(user).to be_valid }
    end

    context 'with more than 255 words' do
      let(:email) { "a" * 244 + "@example.com" }

      it { expect(user.errors[:email]).to include("は255文字以内で入力してください") }
    end

    context 'with a duplicate email address' do
      let(:email) { 'test_email@test.com' }
      let(:duplicate_user) { build(:user, email: user.email) }

      before do
        user.save!
        duplicate_user.valid?
      end

      it { expect(duplicate_user.errors[:email]).to include("はすでに存在します") }
    end

    context 'with an incorrect format email address' do
      let(:email) { 'test_email@test.com' }

      it "is invalid" do
        valid_addresses = %w(user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@bar+baz.com foo@bar..com)
        valid_addresses.each do |valid_address|
          user.email = valid_address
          user.valid?
          expect(user.errors[:email]).to include("は不正な値です")
        end
      end
    end

    context 'with a correct format email address' do
      let(:email) { 'test_email@test.com' }

      it "is valid" do
        valid_addresses = %w(user@example.com  USER@foo.COM A_US-ER@foo.bar.org
                             first.last@foo.jp alice+bob@baz.cn)
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end

    context "saved as lower-case" do
      let(:email) { "Foo@ExAMPle.CoM" }

      before { user.save! }

      it { expect(user.reload.email == user.email.downcase).to be_truthy }
    end
  end

  describe 'password' do
    let(:user) { build(:user, password: password, password_confirmation: password_confirmation) }

    before { user.valid? }

    context 'with less than 6 words' do
      let(:password) { "a" * 5 }
      let(:password_confirmation) { "a" * 5 }

      it { expect(user.errors[:password]).to include("は6文字以上で入力してください") }
    end

    context 'with 6 words or more' do
      let(:password) { "a" * 6 }
      let(:password_confirmation) { "a" * 6 }

      it { expect(user).to be_valid }
    end

    context 'with 6 white space' do
      let(:password) { " " * 6 }
      let(:password_confirmation) { " " * 6 }

      it { expect(user).to be_invalid }
    end

    context "when password matches confirmation" do
      let(:password) { "password" }
      let(:password_confirmation) { "password" }

      it { expect(user).to be_valid }
    end

    context "when password doesn't match confirmation" do
      let(:password) { "password" }
      let(:password_confirmation) { "different" }

      it "is invalid" do
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
    end

    context 'for authentication with a correct password' do
      let(:password) { "password" }
      let(:password_confirmation) { "password" }

      it { expect(user.authenticate(password)).to be_truthy }
    end

    context 'for authentication with an incorrect password' do
      let(:password) { "password" }
      let(:password_confirmation) { "password" }

      it { expect(user.authenticate("")).to be_falsey }
    end
  end
end
