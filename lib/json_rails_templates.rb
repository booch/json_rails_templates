require 'json'

class JsonRailsTemplates
  WHITESPACE_REGEXP = %r(^[\s#{[0x3000].pack("U")}]*)  # 0x3000 = full-width whitespace (stolen from ActiveSupport)
  NON_WHITESPACE_REGEXP = %r([^\s#{[0x3000].pack("U")}])

  attr_accessor :template_text

  def initialize(template_text)
    self.template_text = template_text
  end

  def to_json
    JSON.pretty_generate(to_hash)
  end

  # If you have a procedure with 10 parameters, you probably missed some. -- Alan Perlis
  # If you have a Ruby method with 10 lines, you probably missed some. -- Craig Buchek
  def to_hash
    {}.tap do |hash|
      nesting_depth = 0
      nested_hashes = []
      template_lines.each do |line|
        indentation = line.match(WHITESPACE_REGEXP).to_s.size
        (nesting_depth - indentation / 2).times do
          hash = nested_hashes.pop
          nesting_depth -= 1
        end
        left, right = line.split(':', 2)
        if right.strip.empty?
          hash[left.strip] = {}
          nested_hashes.push(hash)
          hash = hash[left.strip]
          nesting_depth += 1
        else
          hash[left.strip] = eval(right)
        end
      end
    end
  end

  def template_lines
    template_text.lines.reject{|line| line !~ NON_WHITESPACE_REGEXP}
  end
end
