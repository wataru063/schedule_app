require 'rails_helper'

RSpec.describe "Admin::Orders", type: :request do
  let!(:user) { create(:test_user) }
  let!(:order) { create(:order, user_id: user.id) }

  describe "GET #new" do
    subject { get new_admin_order_path, xhr: true }

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
        expect(response.body).to include('オーダー登録')
      end
    end
  end

  describe "POST #create" do
    subject { post '/admin/orders', xhr: true, params: order_params }

    let(:order_params) do
      { order: attributes_for(:order, facility_id: 1, oil_id: 1, user_id: user.id) }
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
        it { expect { subject }.to change(Order, :count).by(1) }
      end

      context 'with invalid params' do
        let(:order_params) { { order: attributes_for(:order, :invalid) } }

        it 'show error messages' do
          subject
          expect(response.body).to include('エラーがあります。')
        end
        it { expect { subject }.not_to change(Order, :count) }
      end
    end
  end

  describe "GET #index" do
    subject { get admin_orders_path, xhr: true }

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

      it 'show order data' do
        subject
        is_expected.to eq(200)
        expect(response.body).to include(order.name)
      end
    end
  end

  describe "GET #search" do
    subject { get admin_orders_search_path, xhr: true, params: { name: order.name } }

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
        it 'shows order data' do
          subject
          is_expected.to eq(200)
          expect(response.body).to include(order.name)
        end
      end

      context "in order to export csv" do
        subject { get admin_orders_search_path, params: { name: '' } }

        it { is_expected.to eq(200) }
      end
    end
  end

  describe "GET #show" do
    subject { get admin_order_path(order), xhr: true }

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
      it 'show modal including the order infomation ' do
        subject
        expect(response.body).to include(order.name)
        expect(response.body).to include(order.company_name)
        expect(response.body).to include(order.shipment.name)
        expect(response.body).to include(order.facility.name)
        expect(response.body).to include(order.oil.name)
        expect(response.body).to include(order.quantity.to_s)
        expect(response.body).to include(order.user.name)
      end
    end
  end

  describe "GET #edit" do
    subject { get edit_admin_order_path(order), xhr: true }

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
        expect(response.body).to include("オーダー編集")
      end
    end
  end

  describe "PATCH #update" do
    subject { patch admin_order_path(order), xhr: true, params: order_params }

    let(:order_params) { { order: attributes_for(:order) } }

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
        it 'show updated order data' do
          subject
          expect(response.body).to include(order_params[:order][:name])
        end
        it 'is expected to change the order name' do
          expect { subject }.to change { Order.find(order.id).name }.
            from(order.name).to(order_params[:order][:name])
        end
      end

      context 'with invalid params' do
        let(:order_params) { { order: attributes_for(:order, :invalid) } }

        it 'show error messages' do
          subject
          expect(response.body).to include('エラーがあります。')
        end
        it { expect { subject }.not_to change { Order.find(order.id).name } }
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete admin_order_path(order), xhr: true }

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

      it 'does not show deleted order data' do
        subject
        expect(response.body).to include('削除しました。')
      end
      it { expect { subject }.to change(Order, :count).by(-1) }
    end
  end
end
