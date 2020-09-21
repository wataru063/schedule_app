require 'rails_helper'

RSpec.describe "GuestSessions", type: :request do
  let!(:guest_user) { create(:guest_user) }

  describe "POST #create" do
    subject { post "/guest_login" }

    it { is_expected.to eq(302) }
    it { is_expected.to redirect_to calendar_index_url }
  end
end
