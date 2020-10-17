require 'rails_helper'

RSpec.describe "Oils", type: :request do
  let!(:facility) { create(:facility) }
  let(:user) { create(:user) }
  let!(:order) { create(:order, user_id: user.id) }

  describe "GET #oil" do
    subject { get oils_select_path, params: { facility_id: Facility.first.id }, xhr: true }

    context "as a guest" do
      it { is_expected.to redirect_to login_url }
    end

    context "as a logged_in user" do
      before { sign_in_as user }

      it { is_expected.to eq(200) }
    end
  end
end
