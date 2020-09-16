require 'rails_helper'

RSpec.describe 'Access to Home', type: :request do
  describe "GET #home" do
    subject { get root_path }

    context "as a guest" do
      it { is_expected.to eq(200) }
    end

    context "as a logged_in user" do
      let(:user) { create(:user) }

      before { sign_in_as user }

      it { is_expected.to redirect_to calendar_index_path }
    end
  end
end
