require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET #new" do
      subject { get login_path }

    context "as a guest" do
      it { is_expected.to eq(200) }
    end

    context "as a logged_in user" do
      before { sign_in_as user }

      it { is_expected.to redirect_to calendar_index_url }
    end
  end

  describe "POST #create" do
    subject { post login_path, params: session_params }

    let(:session_params) { { session: { email: user.email, password: user.password } } }

    context 'as a logged_in user' do
      before { sign_in_as user }

      it { is_expected.to redirect_to calendar_index_url }
    end

    context 'as guest' do
      context 'with valid params' do
        it { is_expected.to eq(302) }
        it { is_expected.to redirect_to calendar_index_url }
      end

      context 'with invalid params' do
        let(:session_params) { { session: { email: '', password: '' } } }

        it { is_expected.to render_template :new }
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete logout_path }

    context 'as a guest' do
      it { is_expected.to redirect_to login_url }
    end

    context 'as a logged_in user' do
      before { sign_in_as user }

      it { is_expected.to redirect_to root_url }
    end
  end
end
