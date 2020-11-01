require 'rails_helper'

RSpec.describe "Admin::Facilities", type: :request do
  let!(:facility) { create(:facility) }
  let!(:oil) { create(:oil) }
  let!(:user) { create(:test_user) }

  describe "GET #new" do
    subject { get new_admin_facility_path, xhr: true }

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
        expect(response.body).to include('荷役設備登録')
      end
    end
  end

  describe "POST #create" do
    subject { post admin_facilities_path, xhr: true, params: facility_params }

    let(:facility_params) { { facility: { name: 'facility', oil_id: { "1" => oil.id } } } }

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
        it { expect { subject }.to change(Facility, :count).by(1) }
      end

      context 'with invalid params' do
        let(:facility_params) { { facility: attributes_for(:facility, :invalid) } }

        it 'show error messages' do
          subject
          expect(response.body).to include('エラーがあります。')
        end
        it { expect { subject }.not_to change(Facility, :count) }
      end
    end
  end

  describe "GET #index" do
    subject { get admin_facilities_path, xhr: true }

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

      it 'show facility data' do
        subject
        is_expected.to eq(200)
        expect(response.body).to include(facility.name)
      end
    end
  end

  describe "GET #search" do
    subject { get admin_facilities_search_path, xhr: true, params: { name: facility.name } }

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

      context "in facility to search" do
        it 'shows facility data' do
          subject
          is_expected.to eq(200)
          expect(response.body).to include(facility.name)
        end
      end

      context "in facility to export csv" do
        subject { get admin_facilities_search_path, params: { name: '' } }

        it { is_expected.to eq(200) }
      end
    end
  end

  describe "GET #show" do
    subject { get admin_facility_path(facility), xhr: true }

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
      it 'show modal including the facility infomation ' do
        subject
        expect(response.body).to include(facility.name)
      end
    end
  end

  describe "GET #edit" do
    subject { get edit_admin_facility_path(facility), xhr: true }

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
        expect(response.body).to include("荷役設備編集")
      end
    end
  end

  describe "PATCH #update" do
    subject { patch admin_facility_path(facility), xhr: true, params: facility_params }

    let(:facility_params) { { facility: { name: 'facility', oil_id: { "1" => oil.id } } } }

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
        it 'show updated facility data' do
          subject
          expect(response.body).to include(facility_params[:facility][:name])
        end
        it 'is expected to change the user name' do
          expect { subject }.to change { Facility.find(facility.id).name }.
            from(facility.name).to(facility_params[:facility][:name])
        end
      end

      context 'with invalid params' do
        let(:facility_params) { { facility: attributes_for(:facility, :invalid) } }

        it 'show error messages' do
          subject
          expect(response.body).to include('エラーがあります。')
        end
        it { expect { subject }.not_to change { Facility.find(facility.id).name } }
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete admin_facility_path(facility), xhr: true }

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

      it 'does not show deleted facility data' do
        subject
        expect(response.body).to include('削除しました。')
      end
      it { expect { subject }.to change(Facility, :count).by(-1) }
    end
  end
end
