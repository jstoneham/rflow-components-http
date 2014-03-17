require 'spec_helper.rb'

describe RFlow::Components::HTTP::Extensions::HTTPRequestExtension do
  before(:each) do
    @schema_string = RFlow::Configuration.available_data_types['RFlow::Message::Data::HTTP::Request']['avro']
  end

  it "should work" do
    RFlow::Configuration.available_data_extensions['RFlow::Message::Data::HTTP::Request'].should include(described_class)

    request = RFlow::Message.new('RFlow::Message::Data::HTTP::Request')
    request.data.uri.should == '/'
    request.data.method.should == 'GET'
    request.data.query_string.should == nil
    request.data.protocol.should == 'HTTP/1.0'
    request.data.headers.should == {}

    request.data.uri = 'POST'
    request.data.uri.should == 'POST'
  end

end

describe RFlow::Components::HTTP::Extensions::HTTPResponseExtension do
  before(:each) do
    @schema_string = RFlow::Configuration.available_data_types['RFlow::Message::Data::HTTP::Response']['avro']
  end

  it "should work" do
    RFlow::Configuration.available_data_extensions['RFlow::Message::Data::HTTP::Response'].should include(described_class)

    response = RFlow::Message.new('RFlow::Message::Data::HTTP::Response')
    response.data.protocol.should == 'HTTP/1.0'
    response.data.status_code.should == 200
    response.data.status_reason_phrase.should == 'OK'
    response.data.headers.should == {}
    response.data.content.should == ''

    response.data.status_code = 404
    response.data.status_code.should == 404
  end

end
