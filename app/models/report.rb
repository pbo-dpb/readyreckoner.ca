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
    @variables = variables
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

    @variables.each do |key,value|
      @variables[key] = Float(value)
    end

    default_options = {
      width: margin_box.width, # 468pt, 6.5in
      column_widths: [180, 72, 72, 72, 72],
      cell_style: {
        borders: [],
      },
    }

    font_size 10
    image Rails.root.join('app', 'assets', 'images', 'header.jpg'), width: margin_box.width
    move_down 20
    text _('All revenue impacts in millions'), align: :center, color: '#999999'

    maximum = 0
    @simulator.sections.each do |section|
      data = [[
        UnicodeUtils.nfc(section.title),
        _('Default'),
        _('Your choice'),
        _('Impact'),
        '',
      ]]

      solutions = []
      section.questions.each do |question|
        max = [question.solve(question.minimum).abs, question.solve(question.maximum).abs].max
        if max > maximum
          maximum = max
        end

        value = @variables.fetch(question.machine_name)
        solution = question.solve(value)
        solutions << solution

        row = [
          UnicodeUtils.nfc(question.name),
          value_formatter(question).call(question.default_value),
          value_formatter(question).call(value),
          precision_formatter.call(solution / 1_000_000.0),
          '',
        ]

        data << row
      end

      move_down 20
      table(data, default_options.merge(header: true)) do
        row(0).font_style = :bold
        columns(1..-1).align = :center

        section.questions.each_with_index do |question,index|
          bar_width = (solutions[index].abs / maximum * 36.0).ceil
          if solutions[index] < 0
            filename = 'negative.png'
            position = 31.0 - bar_width
          else
            filename = 'positive.png'
            position = 31.0
          end

          # Can't call make_cell from within `table` block.
          cells[index + 1, 4] = Prawn::Table::Cell.make(pdf, {
            image: Rails.root.join('app', 'assets', 'images', filename),
            position: position,
            image_width: bar_width,
            image_height: 10,
            borders: [],
          })
        end
      end
    end

    data = [[
      _('Total revenue impacts'),
      '',
      '',
      precision_formatter.call(@simulator.solve(@variables) / 1_000_000.0),
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
