require 'rails_helper'

RSpec.describe "Calendar", type: :request do
  let(:user) { create(:user) }

  describe "GET #index" do
    subject { get calendar_index_path }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as an authenticated user" do
      before { sign_in_as user }

      it { is_expected.to eq(200) }
    end
  end

  describe "GET #show" do
    subject { get calendar_show_path(facility) }

    let(:facility) { create(:facility) }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
    end

    context "as an authenticated user" do
      before { sign_in_as user }

      it { is_expected.to eq(200) }
    end
  end
end
