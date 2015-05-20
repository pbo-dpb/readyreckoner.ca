require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  it 'renders the language switcher if no locale is set' do
    expect(get(:index)).to render_template('pages/switcher')
  end

  context 'with locale' do
    before(:each) do
      CitizenBudgetModel::Simulator.create!(organization_id: 1, name_en_ca: 'A')
      @active = CitizenBudgetModel::Simulator.create!(organization_id: 1, name_en_ca: 'Simulator', active: true)
      CitizenBudgetModel::Simulator.create!(organization_id: 1, name_en_ca: 'B')

      section = CitizenBudgetModel::Section.create!(simulator: @active, title_en_ca: 'Section')
      question = CitizenBudgetModel::Question.create!(section: section, minimum: 1, maximum: 5, step: 2, default_value: 3, unit_value_down: 100, unit_value_up: 100, name: 'Variable', machine_name: 'var')
    end

    describe 'GET index' do
      it 'assigns the active simulator as @simulator' do
        get :index, locale: I18n.default_locale
        expect(response).to be_success
        expect(assigns(:simulator)).to eq(@active)
      end
    end

    describe 'GET print' do
      it 'returns http success on positive solution' do
        post :print, locale: I18n.default_locale, variables: {var: 5}
        expect(response).to be_success
        expect(assigns(:simulator)).to eq(@active)
        expect(response.header['Content-Disposition']).to eq('inline; filename="Ready_Reckoner_Report.pdf"')
        expect(response.header['Content-Type']).to eq('application/pdf')
      end

      it 'returns http success on negative solution' do
        post :print, locale: I18n.default_locale, variables: {var: -5}
        expect(response).to be_success
        expect(assigns(:simulator)).to eq(@active)
        expect(response.header['Content-Disposition']).to eq('inline; filename="Ready_Reckoner_Report.pdf"')
        expect(response.header['Content-Type']).to eq('application/pdf')
      end

      it 'returns http success on zero solution' do
        post :print, locale: I18n.default_locale, variables: {var: 0}
        expect(response).to be_success
        expect(assigns(:simulator)).to eq(@active)
        expect(response.header['Content-Disposition']).to eq('inline; filename="Ready_Reckoner_Report.pdf"')
        expect(response.header['Content-Type']).to eq('application/pdf')
      end
    end
  end
end
