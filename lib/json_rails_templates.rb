require 'json'

class JsonRailsTemplates
  NON_WHITESPACE_REGEXP = %r([^\s#{[0x3000].pack("U")}])  # 0x3000 = full-width whitespace (stolen from ActiveSupport)

  attr_accessor :template_text

  def initialize(template_text)
    self.template_text = template_text
  end

  def to_json
    JSON.pretty_generate(to_hash)
  end

  def to_hash
    attribute_lines = template_text.lines.reject{|line| line !~ NON_WHITESPACE_REGEXP}
    {}.tap do |hash|
      attribute_lines.each do |line|
        left, right = line.split(':', 2)
        hash[left.strip] = eval(right)
      end
    end
  end
end
