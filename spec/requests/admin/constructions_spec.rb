require 'rails_helper'

RSpec.describe "Admin::Constructions", type: :request do
  let!(:user) { create(:test_user) }
  let!(:construction) { create(:construction, user_id: user.id) }

  describe "GET #new" do
    subject { get new_admin_construction_path, xhr: true }

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
        expect(response.body).to include('工事登録')
      end
    end
  end

  describe "POST #create" do
    subject { post '/admin/constructions', xhr: true, params: construction_params }

    let(:construction_params) do
      { construction: attributes_for(:construction, facility_id: 1, oil_id: 1, user_id: user.id) }
    end

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to redirect_to calendar_index_path }
    end

    context "as an admin user" do
      before { sign_in_as user }

      context 'with valid params' do
        it { is_expected.to eq(200) }
        it { expect { subject }.to change(Construction, :count).by(1) }
      end

      context 'with invalid params' do
        let(:construction_params) { { construction: attributes_for(:construction, :invalid) } }

        it 'show error messages' do
          subject
          expect(response.body).to include('エラーがあります。')
        end
        it { expect { subject }.not_to change(Construction, :count) }
      end
    end
  end

  describe "GET #index" do
    subject { get admin_constructions_path, xhr: true }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to redirect_to calendar_index_path }
    end

    context "as an admin user" do
      before { sign_in_as(user) }

      it 'show construction data' do
        subject
        is_expected.to eq(200)
        expect(response.body).to include(construction.name)
      end
    end
  end

  describe "GET #search" do
    subject { get admin_constructions_search_path, xhr: true, params: { name: construction.name } }

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

      context "in construction to search" do
        it 'shows construction data' do
          subject
          is_expected.to eq(200)
          expect(response.body).to include(construction.name)
        end
      end

      context "in construction to export csv" do
        subject { get admin_constructions_search_path, params: { name: '' } }

        it { is_expected.to eq(200) }
      end
    end
  end

  describe "GET #show" do
    subject { get admin_construction_path(construction), xhr: true }

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
      it 'show modal including the construction infomation ' do
        subject
        expect(response.body).to include(construction.name)
        expect(response.body).to include(construction.status.name)
        expect(response.body).to include(construction.oil.name)
        expect(response.body).to include(construction.user.name)
      end
    end
  end

  describe "GET #edit" do
    subject { get edit_admin_construction_path(construction), xhr: true }

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

      it 'is including 登録情報編集' do
        subject
        is_expected.to eq(200)
        expect(response.body).to include("工事編集")
      end
    end
  end

  describe "PATCH #update" do
    subject { patch admin_construction_path(construction), xhr: true, params: construction_params }

    let(:construction_params) { { construction: attributes_for(:construction) } }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to redirect_to calendar_index_path }
    end

    context "as an admin user" do
      before { sign_in_as user }

      context 'with valid params' do
        it 'show updated construction data' do
          subject
          expect(response.body).to include(construction_params[:construction][:name])
        end
        it 'is expected to change the user name' do
          expect { subject }.to change { Construction.find(construction.id).name }.
            from(construction.name).to(construction_params[:construction][:name])
        end
      end

      context 'with invalid params' do
        let(:construction_params) { { construction: attributes_for(:construction, :invalid) } }

        it 'show error messages' do
          subject
          expect(response.body).to include('エラーがあります。')
        end
        it { expect { subject }.not_to change { Construction.find(construction.id).name } }
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete admin_construction_path(construction), xhr: true }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a general user" do
      let(:general_user) { create(:user) }

      before { sign_in_as general_user }

      it { is_expected.to redirect_to calendar_index_path }
    end

    context "as a logged_in user" do
      before { sign_in_as user }

      it 'does not show deleted construction data' do
        subject
        expect(response.body).to include('削除しました。')
      end
      it { expect { subject }.to change(Construction, :count).by(-1) }
    end
  end
end
