require 'rails_helper'

RSpec.describe "Orders", type: :request do
  let!(:facility) { create(:facility) }
  let(:user) { create(:user, category_id: category_id) }
  let(:category_id) { 6 }
  let!(:order) { create(:order, user_id: user.id) }

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

    let(:order_params) do
      { order: attributes_for(:order, facility_id: 1, oil_id: 1, user_id: user.id) }
    end

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
          let(:order_params) { { order: attributes_for(:order, :invalid) } }

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
    subject { get orders_oil_path, params: { facility_id: Facility.first.id }, xhr: true }

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

  describe "GET #show" do
    subject { get order_path(order), xhr: true }

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
        before { get order_path(order), xhr: true }

        it { expect(response.body).to include(order.name) }
      end
    end
  end

  describe "GET #edit" do
    subject { get edit_order_path(order) }

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
        it 'is including 登録情報編集' do
          get edit_order_path(order)
          expect(response.body).to include("登録情報編集")
        end
      end
    end
  end

  describe "PATCH #update" do
    subject { patch order_path(order), params: order_params }

    let(:order_params) { { order: attributes_for(:order) } }

    context 'as a guest' do
      it { is_expected.to redirect_to login_path }
    end

    context "as a logged_in user" do
      context "who is not in charge" do
        let(:other_user) { create(:user) }

        before { sign_in_as other_user }

        it { is_expected.to redirect_to calendar_index_path }
      end

      context 'as an authenticated user' do
        before { sign_in_as user }

        context 'with valid params' do
          it { is_expected.to eq(302) }
          it { is_expected.to redirect_to orders_url }
          it 'is expected to change the order name' do
            expect { subject }.to change { Order.find(order.id).name }.
              from(order.name).to(order_params[:order][:name])
          end
        end

        context 'with invalid params' do
          let(:order_params) { { order: attributes_for(:order, :invalid) } }

          it { is_expected.to render_template :edit }
          it { expect { subject }.not_to change { Order.find(order.id).name } }
        end
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete order_path(order) }

    context 'as a guest' do
      it { is_expected.to redirect_to login_url }
      it { expect { subject }.not_to change(Order, :count) }
    end

    context "as a logged_in user" do
      context "who is not in charge" do
        let(:other_user) { create(:user) }

        before { sign_in_as(other_user) }

        it { expect { subject }.not_to change(Order, :count) }
        it { is_expected.to redirect_to calendar_index_path }
      end

      context 'who is in charge' do
        before { sign_in_as user }

        it { is_expected.to eq(302) }
        it { is_expected.to redirect_to orders_url }
        it { expect { subject }.to change(Order, :count).by(-1) }
      end
    end
  end
end
