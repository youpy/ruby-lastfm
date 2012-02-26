require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Lastfm::Util do
  subject do
    Lastfm::Util
  end

  describe '.build_options' do
    it 'should build options' do
      subject.build_options(
        ['foo', nil],
        [:foo],
        [[:bar, 'xxx'], [:baz, nil]
        ]).should == {
          :foo => 'foo',
          :bar => 'xxx',
          :baz => nil,
        }
    end

    it 'should use proc object to set optional value' do
      subject.build_options(
        ['foo', nil],
        [:foo],
        [[:bar, Proc.new { 'xxx' }]
        ]).should == {
          :foo => 'foo',
          :bar => 'xxx',
        }
    end
  end
end
