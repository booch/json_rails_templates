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
      nesting_level = 0
      nested_hashes = []
      template_lines.each do |line|
        (nesting_level - indentation_level(line)).times do
          hash = nested_hashes.pop
          nesting_level -= 1
        end
        left, right = line.split(':', 2)
        if right.strip.empty?
          hash[left.strip] = {}
          nested_hashes.push(hash)
          hash = hash[left.strip]
          nesting_level += 1
        else
          hash[left.strip] = eval(right)
        end
      end
    end
  end

  def template_lines
    template_text.lines.reject{|line| line !~ NON_WHITESPACE_REGEXP}
  end

  def indentation_level(line)
    leading_whitespace = line.match(WHITESPACE_REGEXP).to_s
    leading_spaces = line.match('[ ]*').to_s

    raise 'Must use only spaces for indentation' if leading_whitespace != leading_spaces
    raise 'Must use 2 spaces for indentation' if leading_spaces.size.odd?

    leading_spaces.size / 2
  end
end
