# require 'rails_helper'
#
# RSpec.feature "Users", type: :feature do
#   let(:user) { build(:user) }
#   let!(:facility) { create(:facility) }
#
#   scenario "user creates a new project" do
#     visit root_path
#     click_link "新規登録"
#     fill_in "ユーザー名", with: user.name
#     # fill_in "メールアドレス", with: user.email
#     # select "設備保全Tm", from: "user_category_id"
#     # fill_in "パスワード", with: user.password
#     # fill_in "パスワード（確認用）", with: user.password
#     # click_button "登録"
#
#        # expect {
#        expect(page).to have_content(user.name)
#        expect(page).to have_content("ホーム")
#     # }.to change(User, :count).by(1)
#   end
# end
