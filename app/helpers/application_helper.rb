module ApplicationHelper
  include CitizenBudgetModel::AdminHelper

  # Returns whether all questions in the section use the same step.
  #
  # @param [CitizenBudgetModel::Section] section a section
  # @return [Boolean] whether all questions in the section use the same step
  def same_step?(section)
    expected = section.questions.first.step
    section.questions.drop(1).all? do |question|
      question.step == expected
    end
  end

  # Formats a record's attribute's value.
  #
  # @param record a record
  # @param [Symbol] attribute an attribute of the record
  # @return [String] a formatted attribute value
  def format(record, attribute)
    value_formatter(record).call(record.send(attribute))
  end

  # @param [CitizenBudgetModel::Question] question a question
  # @return [ActiveSupport::SafeBuffer] an "input" tag of type "range" with a
  #   "datalist" tag describing its options
  # @see http://afarkas.github.io/webshim/demos/demos/cfgs/input-range.html
  def range(question)
    id = "#{question.id}-#{question.name.parameterize}"
    minimum = integer(question.minimum)
    maximum = integer(question.maximum)
    step = integer(question.step)
    default_value = integer(question.default_value)

    options = ActiveSupport::SafeBuffer.new
    (minimum..maximum).step(step) do |value| # range needs min and max to respect step
      # Only display labels for default, minimum and maximum, to avoid crowding.
      attributes = {value: value}
      if [minimum, default_value, maximum].include?(value)
        attributes[:label] = value_formatter(question).call(value)
      end
      options << content_tag('option', nil, attributes)
    end

    tag(:input, {
      id: question.machine_name,
      name: "variables[#{question.machine_name}]",
      type: 'range',
      min: minimum,
      max: maximum,
      step: step,
      value: default_value,
      list: id,
    }) +
    content_tag('datalist', content_tag('select', options), id: id)
  end

private

  def integer(number)
    integer = Integer(number)
    if integer == number
      integer
    else
      number
    end
  end
end
