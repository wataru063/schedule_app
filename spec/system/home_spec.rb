require 'rails_helper'

RSpec.describe "Home", type: :system do
  describe "top_page" do
    context 'access to root_path' do
      before { visit root_path }

      it 'has links sach as root_path, help_path and about_path' do
        # is_expected.to have_link nil, href: root_path, count: 2
        # is_expected.to have_link 'Help', href: help_path
        # is_expected.to have_link 'About', href: about_path
      end
    end
  end

  describe "title" do
    before { visit root_path }

    it "has title '需給管理システム'" do
      expect(title).to include '需給管理システム'
      expect(title).not_to include '| 需給管理システム'
    end
  end
end
