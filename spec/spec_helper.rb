require 'lastfm'

RSpec.configure do |config|
  def fixture(filename)
    File.dirname(__FILE__) + '/fixtures/' + filename
  end

  def make_response(xml_filename_or_string)
    if xml_filename_or_string !~ /</
      xml_filename_or_string = open(fixture(xml_filename_or_string + '.xml')).read
    end

    Lastfm::Response.new(xml_filename_or_string)
  end
  
  def init_lastfm
    @lastfm = Lastfm.new('xxx', 'yyy')
    @response_xml = <<XML
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
<foo>bar</foo></lfm>
XML
    ok_response_xml = <<XML
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
</lfm>
XML
    @ok_response = make_response(ok_response_xml)
  end
end
