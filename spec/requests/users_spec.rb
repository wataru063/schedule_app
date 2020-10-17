require 'rails_helper'

RSpec.describe "Users", js: true, type: :request do
  let!(:user) { create(:user, category_id: 1) }

  describe "GET #new" do
    subject { get login_path }

    context "as a guest" do
      it { is_expected.to eq(200) }
      it 'show signup page' do
        subject
        expect(response.body).to include('新規登録')
      end
    end

    context "as a logged_in user" do
      before { sign_in_as user }

      it { is_expected.to redirect_to calendar_index_url }
    end
  end

  describe "POST #create" do
    subject { post signup_path, params: user_params }

    let(:user_params) { { user: attributes_for(:user, category_id: 1) } }

    context 'as a logged_in user' do
      before { sign_in_as user }

      it { is_expected.to redirect_to calendar_index_url }
    end

    context 'with valid params' do
      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to calendar_index_url }
      it { expect { subject }.to change(User, :count).by(1) }
    end

    context 'with invalid params' do
      let(:user_params) { { user: attributes_for(:user, :invalid, category_id: 1) } }

      it { is_expected.to render_template :new }
      it { expect { subject }.not_to change(User, :count) }
    end
  end

  describe "GET #show" do
      subject { get user_path(user) }

    context "as a guest" do
      it { is_expected.to redirect_to login_url }
    end

    context "as an authenticated user" do
      before { sign_in_as user }

      it { is_expected.to eq(200) }
      it 'render template including the user infomation ' do
        get user_path(user)
        expect(response.body).to include(user.name)
        expect(response.body).to include(user.email)
        expect(response.body).to include(user.category.name)
      end
    end

    context 'to non-existent users' do
      subject { -> { get user_url(100000000) } }

      before { sign_in_as user }

      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe "GET #edit" do
    subject { get edit_user_path(user), xhr: true }

    context "as a guest" do
      it { is_expected.to redirect_to login_url }
    end

    context "as another user" do
      let(:other_user) { create(:user, category_id: 1) }

      before { sign_in_as other_user }

      it { is_expected.to redirect_to user_url(user) }
    end

    context "as an authenticated user" do
      before { sign_in_as user }

      it { is_expected.to eq(200) }
      it 'has .modal("show")' do
        subject
        expect(response.body).to include("$('#editModal').modal('show');")
      end
    end
  end

  describe "PATCH #update" do
    subject { patch user_path(user), params: user_params }

    let(:user_params) { { user: attributes_for(:user, category_id: 1) } }

    context 'as a guest' do
      it { is_expected.to redirect_to login_url }
    end

    context 'as an authenticated user' do
      before { sign_in_as user }

      context 'with valid params' do
        it { is_expected.to eq(302) }
        it { is_expected.to redirect_to user_url(user) }
        it 'is expected to change the user name' do
          expect do
            subject
          end.to change { User.find(user.id).name }.from(user.name).to(user_params[:user][:name])
        end
      end

      context 'with invalid params' do
        let(:user_params) { { user: attributes_for(:user, :invalid, category_id: 1) } }

        it { is_expected.to render_template :show }
        it { expect { subject }.not_to change { User.find(user.id).name } }
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete user_path(user) }

    context 'as a guest' do
      it { is_expected.to redirect_to login_url }
      it { expect { subject }.not_to change(User, :count) }
    end

    context 'as an authenticated user' do
      before { sign_in_as user }

      it { is_expected.to eq(302) }
      it { is_expected.to redirect_to root_url }
      it { expect { subject }.to change(User, :count).by(-1) }
    end
  end
  # TODO   describe "GET #index" do
end
