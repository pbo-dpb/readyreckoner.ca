# @see https://github.com/prawnpdf/prawn/blob/master/lib/prawn/view.rb
class Report
  include Prawn::View

  include CitizenBudgetModel::AdminHelper

  # Generates a report of the impacts of changes to variables.
  #
  # @param [CitizenBudgetModel::Simulator] simulator a simulator
  # @param [Hash{Symbol,String=>Float,String}] variables variables
  def initialize(simulator, variables)
    @simulator = simulator
    @variables = {}

    variables.each do |key,value|
      @variables[key] = Float(value)
    end
  end

  # Sets the document's margins to one inch.
  def document
    @document ||= Prawn::Document.new(margin: 72)
  end

  # Generates the report.
  #
  # @see http://prawnpdf.org/manual.pdf
  # @see http://prawnpdf.org/prawn-table-manual.pdf
  def generate
    # Calculate the maximum bar value.
    maximum = 0
    @simulator.sections.each do |section|
      section.questions.each do |question|
        max = [question.solve(question.minimum).abs, question.solve(question.maximum).abs].max
        if max > maximum
          maximum = max
        end
      end
    end

    bar_cell_width = 36.0
    default_options = {
      width: margin_box.width, # 468pt, 6.5in
      column_widths: [180, 72, 72, 72, 36, 36],
      cell_style: {
        borders: [], # eliminates black border
        padding: [4, 0, 4, 0],
      },
    }

    font_size 10
    image Rails.root.join('app', 'assets', 'images', 'header.jpg'), width: margin_box.width
    move_down 20
    text _('All revenue impacts in millions'), align: :center, color: '#999999'

    @simulator.sections.each do |section|
      # Header row
      data = [[
        UnicodeUtils.nfc(section.title), # merge diacritics and letters
        _('Default'),
        _('Your choice'),
        _('Impact'),
        '',
        '',
      ]]

      # Data rows
      borders = [] # baselines for bars
      section.questions.each_with_index do |question,index|
        value = @variables.fetch(question.machine_name)
        solution = question.solve(value)

        bars = ['', '']
        if solution.zero?
          solution = solution.abs
        else
          bar_width = (solution.abs / maximum * bar_cell_width).ceil

          if solution < 0
            filename = 'negative.png'
            position = bar_cell_width - bar_width
            border = :right
            column = 0
          else
            filename = 'positive.png'
            position = 0
            border = :left
            column = 1
          end

          bars[column] = {
            image: Rails.root.join('app', 'assets', 'images', filename),
            image_width: bar_width,
            image_height: 10,
            position: position,
            padding: [4, 0, 4, 0],
          }

          borders << [column + 4, index + 1, border]
        end

        row = [
          UnicodeUtils.nfc(question.name), # merge diacritics and letters
          value_formatter(question).call(question.default_value),
          value_formatter(question).call(value),
          currency_formatter(precision: 0).call(solution / 1_000_000.0),
          bars[0],
          bars[1],
        ]

        data << row
      end

      # If we set header: true, it's impossible to know which row will break
      # across the page when drawing the bars.
      table(data, default_options) do
        row(0).font_style = :bold
        columns(1..-1).align = :center

        # Setting borders in the cell (above) doesn't seem to work.
        borders.each do |column,row,border|
          columns(column).rows(row).borders = [border]
        end
      end
      move_down 20
    end

    data = [[
      _('Total revenue impacts'),
      '',
      '',
      currency_formatter(precision: 2, significant: true).call(@simulator.solve(@variables) / 1_000_000.0),
      '',
      '',
    ]]

    stroke_horizontal_rule
    move_down 20
    table(data, default_options) do
      row(0).font_style = :bold
      columns(1..-1).align = :center
    end
  end

private

  def number_to_currency(*args)
    ActionController::Base.helpers.number_to_currency(*args)
  end

  def number_to_percentage(*args)
    ActionController::Base.helpers.number_to_percentage(*args)
  end

  def number_with_precision(*args)
    ActionController::Base.helpers.number_with_precision(*args)
  end
end
