class JsonRailsTemplates
  attr_accessor :template_text

  def initialize(template_text)
    self.template_text = template_text
  end

  def to_json
    "{#{template_text.lines.collect{ |line| one_line_to_json(line) }.join(",\n")}}"
  end

private

  def one_line_to_json(line)
    left, right = line.split(':', 2)
    left = left.strip
    right = eval(right.strip)
    right = one_item_to_json(right)
    %("#{left}": #{right})
  end

  def one_item_to_json(item)
    case item
    when String
      %("#{item}")
    when Integer, Float, TrueClass, FalseClass
      item.to_s
    when NilClass
      'null'
    when Array
      %([#{item.collect{|sub_item| one_item_to_json(sub_item)}.join(', ')}])
    end
  end
end
