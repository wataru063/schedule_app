require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:construction) { create(:construction) }

  describe "POST #create" do
    subject { post comments_path, params: comment_params, xhr: true }

    let(:comment_params) { { comment: attributes_for(:comment, construction_id: construction.id) } }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
      it { expect { subject }.not_to change(Comment, :count) }
    end

    context "as a logged_in user" do
      before { sign_in_as(user) }

      context 'with valid params' do
          it { is_expected.to eq(200) }
          it { expect { subject }.to change(Comment, :count).by(1) }
      end

      context 'with invalid params' do
        let(:comment_params) { { comment: attributes_for(:comment, :invalid) } }

        it { is_expected.to render_template 'calendar/index' }
        it { expect { subject }.not_to change(Comment, :count) }
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete comment_path(comment), xhr: true }

    let!(:comment) { create(:comment, user_id: user.id, construction_id: construction.id) }

    context "as a guest" do
      it { is_expected.to redirect_to login_path }
      it { expect { delete comment_path(comment.id), xhr: true }.not_to change(Comment, :count) }
    end

    context "as a logged_in user" do
      context 'who is authenticated' do
        before { sign_in_as user }

        it { is_expected.to eq(200) }
        it { expect { subject }.to change(Comment, :count).by(-1) }
      end
    end
  end

  # TODO   describe "GET #edit" do
  # TODO   describe "PATCH #update" do
end
