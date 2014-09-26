class PagesController < ApplicationController
  def index
    @simulator = CitizenBudgetModel::Simulator.includes([:translations, {sections: [:translations, {questions: :translations}]}]).first
  end

  def print
  end
end
