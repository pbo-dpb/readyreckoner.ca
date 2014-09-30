require 'rails_helper'

RSpec.describe PagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/').to route_to('pages#index')
    end

    it 'routes to #print' do
      expect(post: '/print').to route_to('pages#print')
    end
  end
end
