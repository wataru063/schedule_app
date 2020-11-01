require 'rails_helper'

RSpec.describe "Constructions", type: :request do
  let!(:facility) { create(:facility) }
  let(:user) { create(:user, category_id: category_id) }
  let(:category_id) { 1 }
  let!(:construction) { create(:construction, user_id: user.id) }

  describe "GET #new" do
    subject do
      get new_construction_path, xhr: true, params: { facility_id: construction.facility_id }
    end

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a logged_in user" do
      before { sign_in_as(user) }

      context "who is not in charge" do
        let(:category_id) { 6 }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context "who is in charge" do
        it { is_expected.to eq(200) }
        it 'show construction registration page' do
          subject
          expect(response.body).to include('工事登録')
        end
      end
    end
  end

  describe "POST #create" do
    subject { post constructions_path, xhr: true, params: construction_params }

    let(:construction_params) { { construction: attributes_for(:construction) } }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a logged_in user" do
      before { sign_in_as(user) }

      context "who is not in charge" do
        let(:category_id) { 6 }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context "who is in charge" do
        context 'with valid params' do
          it { is_expected.to eq(200) }
          it { expect { subject }.to change(Construction, :count).by(1) }
        end

        context 'with invalid params' do
          let(:construction_params) do
            { construction: attributes_for(:construction, :invalid) }
          end

          it { is_expected.to render_template 'shared/_error_messages', 'constructions/create' }
          it { expect { subject }.not_to change(Construction, :count) }
        end
      end
    end
  end

  describe "GET #index" do
    subject { get constructions_path }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as an authenticated user" do
      before { sign_in_as(user) }

      it { is_expected.to eq(200) }
      it 'show constructions index page' do
        subject
        expect(response.body).to include('工事一覧')
      end
    end
  end

  describe "GET #show" do
    subject { get construction_path(construction), xhr: true }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as an authenticated user" do
      before { sign_in_as(user) }

      it { is_expected.to eq(200) }
      it 'show construction detail show page' do
        subject
        expect(response.body).to include(construction.name)
      end
    end
  end

  describe "GET #search" do
    subject { get constructions_search_path }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as an authenticated user" do
      before { sign_in_as(user) }

      context "in order to export csv" do
        subject { get constructions_search_path, params: { column: true } }

        it { is_expected.to eq(200) }
      end

      context "in order to search by key word" do
        it { is_expected.to eq(200) }
        it { is_expected.to render_template :index }
        it 'show constructions index page' do
          subject
          expect(response.body).to include(construction.name)
        end
      end
    end
  end

  describe "GET #edit" do
    subject { get edit_construction_path(construction) }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a logged_in user" do
      context "who is not in charge" do
        let(:other_user) { create(:user) }

        before { sign_in_as(other_user) }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context "who is in charge" do
        before { sign_in_as(user) }

        it { is_expected.to eq(200) }
        it do
          get edit_construction_path(construction)
          expect(response.body).to include("登録情報編集")
        end
      end
    end
  end

  describe "PATCH #update" do
    subject { patch construction_path(construction), params: construction_params }

    let(:construction_params) { { construction: attributes_for(:construction) } }

    context 'as a guest' do
      it { is_expected.to redirect_to login_path }
    end

    context "as a logged_in user" do
      context "who is not in charge" do
        let(:other_user) { create(:user) }

        before { sign_in_as(other_user) }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context 'as an authenticated user' do
        before { sign_in_as user }

        context 'with valid params' do
          it { is_expected.to eq(302) }
          it { is_expected.to redirect_to calendar_index_url }
          it 'is expected to change the user name' do
            expect { subject }.to change { Construction.find(construction.id).name }.
              from(construction.name).to(construction_params[:construction][:name])
          end
        end

        context 'with invalid params' do
          let(:construction_params) { { construction: attributes_for(:construction, :invalid) } }

          it { is_expected.to render_template :edit }
          it { expect { subject }.not_to change { Construction.find(construction.id).name } }
        end
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete construction_path(construction) }

    context 'as a guest' do
      it { is_expected.to redirect_to login_url }
      it { expect { subject }.not_to change(Construction, :count) }
    end

    context "as a logged_in user" do
      context "who is not in charge" do
        let(:other_user) { create(:user) }

        before { sign_in_as(other_user) }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context 'who is in charge' do
        before { sign_in_as user }

        it { is_expected.to eq(302) }
        it { is_expected.to redirect_to constructions_url }
        it { expect { subject }.to change(Construction, :count).by(-1) }
      end
    end
  end
end
