require 'rails_helper'

RSpec.describe "Facilities", type: :request do
  describe "GET #new" do
    subject { get facility_path }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    # TODO admin user only accessable
    context "as an authenticated user" do
      let(:user) { create(:user) }

      before { sign_in_as user }

      it { is_expected.to eq(200) }
    end
  end
end
