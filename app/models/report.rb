# @see https://github.com/prawnpdf/prawn/blob/master/lib/prawn/view.rb
class Report
  include Prawn::View

  def document
    @document ||= Prawn::Document.new(margin: 72) # 72 points, 1 inch
  end

  def initialize
  end

  def generate
    # @see http://prawnpdf.org/manual.pdf from page 79
    image Rails.root.join('app', 'assets', 'images', 'header.jpg'), width: margin_box.width
  end
end
