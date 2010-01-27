$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'lastfm'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  def fixture(filename)
    File.dirname(__FILE__) + '/fixtures/' + filename
  end

  def make_response(xml_filename_or_string)
    if xml_filename_or_string !~ /</
      xml_filename_or_string = open(fixture(xml_filename_or_string + '.xml')).read
    end

    Lastfm::Response.new(xml_filename_or_string)
  end
end
