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
    pdf = document # document method is not accessible inside Prawn block

    bar_cell_width = 36.0
    default_options = {
      width: margin_box.width, # 468pt, 6.5in
      column_widths: [180, 72, 72, 72, 36, 36],
      cell_style: {
        borders: [], # eliminates black border
        padding: [5, 0, 5, 0],
      },
    }

    font_size 10
    image Rails.root.join('app', 'assets', 'images', 'header.jpg'), width: margin_box.width
    move_down 20
    text _('All revenue impacts in millions'), align: :center, color: '#999999'

    maximum = 0 # maximum bar value
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
      solutions = [] # for bar graph
      section.questions.each do |question|
        max = [question.solve(question.minimum).abs, question.solve(question.maximum).abs].max
        if max > maximum
          maximum = max
        end

        value = @variables.fetch(question.machine_name)
        solution = question.solve(value)
        solutions << solution

        row = [
          UnicodeUtils.nfc(question.name), # merge diacritics and letters
          value_formatter(question).call(question.default_value),
          value_formatter(question).call(value),
          currency_formatter.call(solution / 1_000_000.0),
          '',
          '',
        ]

        data << row
      end

      move_down 20
      table(data, default_options.merge(header: true)) do
        row(0).font_style = :bold
        columns(1..-1).align = :center

        section.questions.each_with_index do |question,index|
          if solutions[index].nonzero?
            bar_width = (solutions[index].abs / maximum * bar_cell_width).ceil
            if solutions[index] < 0
              filename = 'negative.png'
              position = bar_cell_width - bar_width
              column = 4
              border = :right
            else
              filename = 'positive.png'
              position = 0
              column = 5
              border = :left
            end

            # Can't call make_cell from within `table` block.
            cells[index + 1, column] = Prawn::Table::Cell.make(pdf, {
              image: Rails.root.join('app', 'assets', 'images', filename),
              position: position,
              image_width: bar_width,
              image_height: 10,
              borders: [border],
              padding: [5, 0, 5, 0],
            })
          end
        end
      end
    end

    data = [[
      _('Total revenue impacts'),
      '',
      '',
      currency_formatter.call(@simulator.solve(@variables) / 1_000_000.0),
      '',
      '',
    ]]

    move_down(20)
    stroke_horizontal_rule
    move_down(20)
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
