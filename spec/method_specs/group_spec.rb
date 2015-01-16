require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#group' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Group' do
    @lastfm.group.should be_an_instance_of(Lastfm::MethodCategory::Group)
  end

  describe '#get_members' do
    it 'should get the members\' info' do
      @lastfm.should_receive(:request).with('group.getMembers', {
        :group => 'Linux',
        :limit => nil,
        :page => nil
      }).and_return(make_response('group_get_members'))
      members = @lastfm.group.get_members(:group => 'Linux')
      members[0]['name'].should == 'RJ'
      members.size.should == 1
    end
  end
end
