class PagesController < ApplicationController
  def index
    @simulator = CitizenBudgetModel::Simulator.where(active: true).includes([:translations, {sections: [:translations, {questions: :translations}]}]).first!
  end

  def print
    report = Report.new
    report.generate
    send_data report.render, disposition: 'inline', filename: 'Ready_Reckoner_Report.pdf', type: 'application/pdf'
  end
end
