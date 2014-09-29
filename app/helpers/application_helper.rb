module ApplicationHelper
  include CitizenBudgetModel::AdminHelper

  def same_step?(section)
    expected = section.questions.first.step
    section.questions.drop(1).all? do |question|
      question.step == expected
    end
  end

  def format(record, attribute)
    value_formatter(record).call(record.send(attribute))
  end

  def range(question)
    id = "#{question.id}-#{question.name.parameterize}"
    minimum = integer(question.minimum)
    maximum = integer(question.maximum)
    step = integer(question.step)
    default_value = integer(question.default_value)

    options = ActiveSupport::SafeBuffer.new
    (minimum..maximum).step(step) do |value|
      # Only display labels for default, minimum and maximum, to avoid crowding.
      if [minimum, default_value, maximum].include?(value)
        options << content_tag('option', nil, value: value, label: value_formatter(question).call(value))
      end
    end

    tag(:input, {
      id: question.machine_name,
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
