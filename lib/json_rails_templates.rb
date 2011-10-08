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
    right = case right
            when String
              %('#{right}')
            when Integer, Float, TrueClass, FalseClass
              right.to_s
            end
    "#{left}: #{right}"
  end
end
