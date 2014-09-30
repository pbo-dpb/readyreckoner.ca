class PagesController < ApplicationController
  before_action :set_simulator

  def index
  end

  def print
    report = Report.new(@simulator, params[:variables])
    report.generate
    send_data report.render, disposition: 'inline', filename: 'Ready_Reckoner_Report.pdf', type: 'application/pdf'
  end

private

  def set_simulator
    @simulator = CitizenBudgetModel::Simulator.where(active: true).includes([:translations, {sections: [:translations, {questions: :translations}]}]).first!
  end
end
