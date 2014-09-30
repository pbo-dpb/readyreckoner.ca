require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  it 'renders the language switcher if no locale is set' do
    expect(get(:index)).to render_template('pages/switcher')
  end

  context 'with locale' do
    describe 'GET index' do
      it 'assigns the active simulator as @simulator' do
        CitizenBudgetModel::Simulator.create!(organization_id: 1, name_en_ca: 'A')
        active = CitizenBudgetModel::Simulator.create!(organization_id: 1, name_en_ca: 'Simulator', active: true)
        CitizenBudgetModel::Simulator.create!(organization_id: 1, name_en_ca: 'B')

        get :index, locale: I18n.default_locale
        expect(response).to be_success
        expect(assigns(:simulator)).to eq(active)
      end
    end

    describe 'GET print' do
      it 'returns http success' do
        post :print, locale: I18n.default_locale
        expect(response).to be_success
        expect(response.header['Content-Disposition']).to eq('inline; filename="Ready_Reckoner_Report.pdf"')
        expect(response.header['Content-Type']).to eq('application/pdf')
      end
    end
  end
end
