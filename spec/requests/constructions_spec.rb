require 'rails_helper'

RSpec.describe "Constructions", type: :request do
  let(:user) { create(:user, category_id: category_id) }
  let(:category_id) { 1 }

  describe "GET #new" do
    subject { get new_construction_path }

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
      end
    end
  end

  describe "POST #create" do
    subject { post constructions_path, params: construction_params }

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
          it { is_expected.to eq(302) }
          it { is_expected.to redirect_to new_construction_url }
          it { expect { subject }.to change(Construction, :count).by(1) }
        end

        context 'with invalid params' do
          let(:construction_params) do
            { construction: attributes_for(:construction, :invalid) }
          end

          it { is_expected.to render_template :new }
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
    end
  end

  describe "GET #show" do
    subject { get construction_path(construction), xhr: true }

    let(:construction) { create(:construction) }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as an authenticated user" do
      before { sign_in_as(user) }

      it { is_expected.to eq(200) }
    end
  end

  describe "GET #search" do
    subject { get constructions_search_path }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as an authenticated user" do
      before { sign_in_as(user) }

      it { is_expected.to eq(200) }
      it { is_expected.to render_template :index }
    end
  end

  # TODO   describe "GET #edit" do
  # TODO   describe "PATCH #update" do
  # TODO   describe "DELETE#destroy" do
end
