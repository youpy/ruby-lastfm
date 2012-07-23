require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Lastfm::Util do
  subject do
    Lastfm::Util
  end

  describe '.build_options' do
    describe 'with array' do
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

      it 'should raise error if required option is not passed' do
        lambda {
          subject.build_options(
            [],
            [:foo],
            [[:bar, 'xxx'], [:baz, nil]
            ])
        }.should raise_error('foo is required')
      end
    end

    describe 'with hash' do
      it 'should build options' do
        subject.build_options(
          [
            {
              :foo => 'foo',
              :bar => nil,
              :baz => 'baz'
            }
          ],
          [:foo],
          [
            [:bar, 'xxx'],
            [:baz, nil]
          ]).should ==  {
          :foo => 'foo',
          :bar => 'xxx',
          :baz => 'baz',
        }
      end

      it 'should use proc object to set optional value' do
        subject.build_options(
          [
            {
              :foo => 'foo',
              :bar => nil,
            }
          ],
          [:foo],
          [[:bar, Proc.new { 'xxx' }]
          ]).should == {
          :foo => 'foo',
          :bar => 'xxx',
        }
      end

      it 'should raise error if required option is not passed' do
        lambda {
          subject.build_options(
            [
              {
                :bar => nil,
                :baz => 'baz'
              }
            ],
            [:foo],
            [
              [:bar, 'xxx'],
              [:baz, nil]
            ])
        }.should raise_error('foo is required')
      end
    end
  end
end
