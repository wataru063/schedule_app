require 'rails_helper'

RSpec.describe 'Access to static_pages', type: :request do
  context 'GET #home' do
    before { get root_path }

    it 'responds successfully' do
      expect(response).to have_http_status 200
    end
    it "has title '需給管理システム'" do
      expect(response.body).to include '需給管理システム'
      expect(response.body).not_to include '| 需給管理システム'
    end
  end
end
