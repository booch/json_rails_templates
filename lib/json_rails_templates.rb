class JsonRailsTemplates
  NON_WHITESPACE_REGEXP = %r![^\s#{[0x3000].pack("U")}]!  # 0x3000 = fullwidth whitespace (stolen from ActiveSupport)

  attr_accessor :template_text

  def initialize(template_text)
    self.template_text = template_text
  end

  def to_json
    "{#{template_text.lines.reject{|line| line !~ NON_WHITESPACE_REGEXP}.collect{ |line| one_line_to_json(line) }.join(",\n")}}"
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
    when Hash
      hash_to_json(item)
    when NilClass
      'null'
    when Array
      %([#{item.collect{|sub_item| one_item_to_json(sub_item)}.join(', ')}])
    end
  end

  def hash_to_json(hash)
    '{' + hash.map{|key, value| %("#{key.to_s}": #{one_item_to_json(value)})}.join(', ') + '}'
  end
end
