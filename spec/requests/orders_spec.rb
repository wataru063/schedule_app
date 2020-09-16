require 'rails_helper'

RSpec.describe "Orders", type: :request do
  let(:user) { create(:user, category_id: category_id) }
  let(:category_id) { 6 }

  describe "GET #new" do
    subject { get new_order_path }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a logged_in user" do
      before { sign_in_as(user) }

      context "who is not in charge" do
        let(:category_id) { 1 }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context "who is in charge" do
        it { is_expected.to eq(200) }
      end
    end
  end

  describe "POST #create" do
    subject { post orders_path, params: order_params }

    let(:order_params) { { order: attributes_for(:order) } }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a logged_in user" do
      before { sign_in_as(user) }

      context "who is not in charge" do
        let(:category_id) { 1 }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context "who is in charge" do
        context 'with valid params' do
          it { is_expected.to eq(302) }
          it { is_expected.to redirect_to new_order_url }
          it { expect { subject }.to change(Order, :count).by(1) }
        end

        context 'with invalid params' do
          let(:order_params) { { order: FactoryBot.attributes_for(:order, :invalid) } }

          it { is_expected.to render_template :new }
          it { expect { subject }.not_to change(Order, :count) }
        end
      end
    end
  end

  describe "GET #index" do
    subject { get orders_path }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as a logged_in user" do
      before { sign_in_as(user) }

      context "who is not in charge" do
        let(:category_id) { 1 }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context "who is in charge" do
        it { is_expected.to eq(200) }
      end
    end
  end

  describe "GET #search" do
    subject { get orders_search_path }

    context "as a guest" do
      it { is_expected.to redirect_to login_url }
    end

    context "as a logged_in user" do
      before do
        sign_in_as user
        get orders_path
      end

      context "who is not in charge" do
        let(:category_id) { 1 }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context "who is in charge" do
        it { is_expected.to eq(200) }
        it { is_expected.to render_template :index }
      end
    end
  end

  describe "GET #oil" do
    subject { get orders_oil_path, params: { facility_id: 1 }, xhr: true }

    context "as a guest" do
      it { is_expected.to redirect_to login_url }
    end

    context "as a logged_in user" do
      before do
        sign_in_as user
        get new_order_path
      end

      context "who is not in charge" do
        let(:category_id) { 1 }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context "who is in charge" do
        it { is_expected.to eq(200) }
      end
    end
  end

  # TODO   describe "GET #show" do
  # TODO   describe "GET #edit" do
  # TODO   describe "PATCH #update" do
  # TODO   describe "DELETE #destroy" do
end
