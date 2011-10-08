require 'json_rails_templates'

describe 'JsonRailsTemplates' do
  describe '.to_json' do
    subject { JsonRailsTemplates.new(template_text).to_json }
    let(:template_text) { '' } # NOTE: We'll override this for each spec below.

    context 'for a string literal' do
      let(:template_text) { %(string_literal: 'this is a string') }
      it { should == %({string_literal: 'this is a string'}) }
    end

    context 'for an integer literal' do
      let(:template_text) { %(integer_literal: 123) }
      it { should == %({integer_literal: 123}) }
    end

    context 'for a float literal' do
      let(:template_text) { %(float_literal: 1.234) }
      it { should == %({float_literal: 1.234}) }
    end

    context 'for a boolean literal' do
      let(:template_text) { %(boolean_literal: true) }
      it { should == %({boolean_literal: true}) }
    end

    context 'for multiple simple literals' do
      let(:template_text) { %(boolean_literal: false\ninteger_literal: 1) }
      it { should == %({boolean_literal: false,\ninteger_literal: 1}) }
    end

    context 'for a string expression' do
      let(:template_text) { %(string_expression: 'this is a string'.gsub('string', 'String!')) }
      it { should == %({string_expression: 'this is a String!'}) }
    end

    context 'for an integer expression' do
      let(:template_text) { %(integer_expression: 1 + 2) }
      it { should == %({integer_expression: 3}) }
    end

    context 'for a float expression' do
      let(:template_text) { %(float_expression: Math::PI * 2) }
      it { should == %({float_expression: 6.283185307179586}) }
    end

    context 'for a boolean expression' do
      let(:template_text) { %(boolean_expression: 'Craig' == 'Buchek') }
      it { should == %({boolean_expression: false}) }
    end
  end
end
