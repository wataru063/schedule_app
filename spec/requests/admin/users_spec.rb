require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let!(:user) { create(:test_user) }

  describe "GET #index" do
    subject { get admin_users_path }

    context "as a guest" do
      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to calendar_index_path }
    end

    context "as an admin user" do
      before { sign_in_as user }

      it 'show user data' do
        subject
        is_expected.to eq(200)
        expect(response.body).to include(user.name)
      end
    end
  end

  describe "GET #search" do
    subject { get admin_users_search_path, xhr: true, params: { name: user.name } }

    context "as a guest" do
      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to calendar_index_path }
    end

    context "as an admin user" do
      before { sign_in_as user }

      context "in order to search" do
        it 'shows user data' do
          subject
          is_expected.to eq(200)
          expect(response.body).to include(user.name)
        end
      end

      context "in order to export csv" do
        subject { get admin_users_search_path }

        it { is_expected.to eq(200) }
      end
    end
  end

  describe "GET #new" do
    subject { get new_admin_user_path, xhr: true }

    context "as a guest" do
      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to calendar_index_path }
    end

    context "as an admin user" do
      before { sign_in_as user }

      it 'shows the page title' do
        subject
        is_expected.to eq(200)
        expect(response.body).to include('ユーザー登録')
      end
    end
  end

  describe "POST #create" do
    subject { post "/admin/users", xhr: true, params: user_params }

    let(:user_params) { { user: attributes_for(:user) } }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to redirect_to calendar_index_path }
    end

    context 'as an admin user' do
      before { sign_in_as user }

      context 'with valid params' do
        it { expect { subject }.to change(User, :count).by(1) }
        it 'show new user data' do
          subject
          expect(response.body).to include(user.name)
        end
      end

      context 'with invalid params' do
        let(:user_params) { { user: attributes_for(:user, :invalid) } }

        it 'show error messages' do
          subject
          expect(response.body).to include('エラーがあります。')
        end
        it { expect { subject }.not_to change(User, :count) }
      end
    end
  end

  describe "GET #show" do
    subject { get admin_user_path(user), xhr: true }

    context "as a guest" do
      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to calendar_index_path }
    end

    context "as an admin user" do
      before { sign_in_as user }

      context 'to existing users' do
        it { is_expected.to eq(200) }
        it 'show modal including the user infomation ' do
          subject
          expect(response.body).to include(user.name)
          expect(response.body).to include(user.email)
          expect(response.body).to include(user.category.name)
          expect(response.body).to include(user.orders[1].name)
        end
      end
    end
  end

  describe "GET #edit" do
    subject { get edit_admin_user_path(user), xhr: true }

    context "as a guest" do
      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to calendar_index_path }
    end

    context "as an admin user" do
      before { sign_in_as user }

      it { is_expected.to eq(200) }
      it 'shows edit form' do
        subject
        expect(response.body).to include("ユーザー編集")
        expect(response.body).to include(user.name)
      end
    end
  end

  describe "PATCH #update" do
    subject { patch admin_user_path(user), xhr: true, params: user_params }

    let(:user_params) { { user: attributes_for(:user) } }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to redirect_to calendar_index_path }
    end

    context 'as an admin user' do
      before { sign_in_as user }

      context 'with valid params' do
        it 'show updated user data' do
          subject
          expect(response.body).to include(user_params[:user][:name])
        end
        it 'is expected to change the user name' do
          expect do
            subject
          end.to change { User.find(user.id).name }.from(user.name).to(user_params[:user][:name])
        end
      end

      context 'with invalid params' do
        let(:user_params) { { user: attributes_for(:user, :invalid) } }

        it 'show error messages' do
          subject
          expect(response.body).to include('エラーがあります。')
        end
        it { expect { subject }.not_to change { User.find(user.id).name } }
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete admin_user_path(another_user), xhr: true }

    let!(:another_user) { create(:user) }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to redirect_to calendar_index_path }
    end

    context 'as an admin user' do
      before { sign_in_as user }

      it 'does not show deleted user data' do
        subject
        expect(response.body).to include('削除しました。')
      end
      it { expect { subject }.to change(User, :count).by(-1) }
    end
  end
end
