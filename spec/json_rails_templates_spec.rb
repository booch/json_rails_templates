require 'json_rails_templates'

describe 'JsonRailsTemplates' do
  describe '.to_json' do
    subject { JsonRailsTemplates.new(template_text).to_json }
    let(:template_text) { '' } # NOTE: We'll override this for each spec below.

    context 'for blank lines' do
      let(:template_text) { "\n\n\n" }
      it { should == %({\n}) }
    end

    context 'for a string literal' do
      let(:template_text) { %(string_literal: 'this is a string') }
      it { should == %({\n  "string_literal": "this is a string"\n}) }
    end

    context 'for a string expression' do
      let(:template_text) { %(string_expression: 'this is a string'.gsub('string', 'String!')) }
      it { should == %({\n  "string_expression": "this is a String!"\n}) }
    end

    context 'for an integer literal' do
      let(:template_text) { %(integer_literal: 123) }
      it { should == %({\n  "integer_literal": 123\n}) }
    end

    context 'for an integer expression' do
      let(:template_text) { %(integer_expression: 1 + 2) }
      it { should == %({\n  "integer_expression": 3\n}) }
    end

    context 'for a float literal' do
      let(:template_text) { %(float_literal: 1.234) }
      it { should == %({\n  "float_literal": 1.234\n}) }
    end

    context 'for a float expression' do
      let(:template_text) { %(float_expression: Math::PI * 2) }
      it { should == %({\n  "float_expression": 6.283185307179586\n}) }
    end

    context 'for a boolean literal' do
      let(:template_text) { %(boolean_literal: true) }
      it { should == %({\n  "boolean_literal": true\n}) }
    end

    context 'for a boolean expression' do
      let(:template_text) { %(boolean_expression: 'Craig' == 'Buchek') }
      it { should == %({\n  "boolean_expression": false\n}) }
    end

    context 'for nil' do
      let(:template_text) { %(null_literal: nil) }
      it { should == %({\n  "null_literal": null\n}) }
    end

    context 'for an array literal' do
      let(:template_text) { %(array_literal: ['string', 123, 1.234, false]) }
      it { should == %({\n  "array_literal": [\n    "string",\n    123,\n    1.234,\n    false\n  ]\n}) }
    end

    context 'for an array expression' do
      let(:template_text) { %(array_expression: Array.new(3, 'hello')) }
      it { should == %({\n  "array_expression": [\n    "hello",\n    "hello",\n    "hello"\n  ]\n}) }
    end

    context 'for a hash literal' do
      let(:template_text) { %(hash_literal: {a: 1, b: '2', 'c' => 3}) }
      it { should == %({\n  "hash_literal": {\n    "a": 1,\n    "b": "2",\n    "c": 3\n  }\n}) }
    end

    context 'for a nested hash literal' do
      let(:template_text) { %(nested_hash_literal: {a: {:b => {'c' => 3}}}) }
      it { should == %({\n  "nested_hash_literal": {\n    "a": {\n      "b": {\n        "c": 3\n      }\n    }\n  }\n}) }
    end

    context 'for nested contexts' do
      let(:template_text) { %(nested_contexts:\n  child:\n    grandchild: 1\n) }
      it { should == %({
  "nested_contexts": {
    "child": {
      "grandchild": 1
    }
  }
}) }
    end

    context 'using tabs for indenting' do
      let(:template_text) { %(nested_contexts:\n\t\tchild:\n\t\tgrandchild: 1\n) }
      it 'raises an exception' do
        expect { subject }.to raise_exception
      end
    end

    context 'using an odd number of spaces for indenting' do
      let(:template_text) { %(nested_contexts:\n   child:\n    grandchild: 1\n) }
      it 'raises an exception' do
        expect { subject }.to raise_exception
      end
    end

    context 'for multiple simple literals' do
      let(:template_text) { %(boolean_literal: false\ninteger_literal: 1) }
      it { should == %({\n  "boolean_literal": false,\n  "integer_literal": 1\n}) }
    end

    context 'everything put together' do
      let(:template_text) {%(
string_literal: 'this is a string'
string_expression: 'this is a string'.gsub('string', 'String!')
integer_literal: 123
integer_expression: 1 + 2
float_literal: 1.234
float_expression: Math::PI * 2
boolean_literal: true
boolean_expression: 'Craig' == 'Buchek'
null_literal: nil
array_literal: ['string', 123, 1.234, false]
array_expression: Array.new(3, 'hello')
hash_literal: {a: 1, b: '2', 'c' => 3}
nested_contexts:
  child:
    grandchild: 1
nested_hash_literal: {a: {:b => {'c' => 3}}}
      )}
      it { should == %({
  "string_literal": "this is a string",
  "string_expression": "this is a String!",
  "integer_literal": 123,
  "integer_expression": 3,
  "float_literal": 1.234,
  "float_expression": 6.283185307179586,
  "boolean_literal": true,
  "boolean_expression": false,
  "null_literal": null,
  "array_literal": [
    "string",
    123,
    1.234,
    false
  ],
  "array_expression": [
    "hello",
    "hello",
    "hello"
  ],
  "hash_literal": {
    "a": 1,
    "b": "2",
    "c": 3
  },
  "nested_contexts": {
    "child": {
      "grandchild": 1
    }
  },
  "nested_hash_literal": {
    "a": {
      "b": {
        "c": 3
      }
    }
  }
})
      }
    end
  end
end
