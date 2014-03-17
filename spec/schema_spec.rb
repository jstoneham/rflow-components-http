require 'spec_helper.rb'

describe 'RFlow::Message::Data::HTTP::Request Avro Schema' do
  before(:each) do
    @schema_string = RFlow::Configuration.available_data_types['RFlow::Message::Data::HTTP::Request']['avro']
  end

  it "should encode and decode an object" do
    request = {
      'method' => 'METHOD',
      'uri' => 'URI',
      'query_string' => 'QUERYSTRING',
      'protocol' => 'PROTOCOL',
      'headers' => {
        'header1' => 'HEADER1',
        'header2' => 'HEADER2',
      },
      'content' => '',
    }

    expect {encode_avro(@schema_string, request)}.to_not raise_error
    avro_encoded_request = encode_avro(@schema_string, request)

    expect {decode_avro(@schema_string, avro_encoded_request)}.to_not raise_error
    decoded_request = decode_avro(@schema_string, avro_encoded_request)

    decoded_request['method'].should == request['method']
    decoded_request['uri'].should == request['uri']
    decoded_request['query_string'].should == request['query_string']
    decoded_request['protocol'].should == request['protocol']
    decoded_request['headers'].should == request['headers']
    decoded_request['content'].should == request['content']
  end
end


describe 'RFlow::Message::Data::HTTP::Response Avro Schema' do
  before(:each) do
    @schema_string = RFlow::Configuration.available_data_types['RFlow::Message::Data::HTTP::Response']['avro']
  end

  it "should encode and decode an object" do
    response = {
      'protocol' => 'METHOD',
      'status_code' => 200,
      'status_reason_phrase' => 'STATUSREASONPHRASE',
      'headers' => {
        'header1' => 'HEADER1',
        'header2' => 'HEADER2',
      },
      'content' => 'CONTENT',
    }

    expect {encode_avro(@schema_string, response)}.to_not raise_error
    avro_encoded_response = encode_avro(@schema_string, response)

    expect {decode_avro(@schema_string, avro_encoded_response)}.to_not raise_error
    decoded_response = decode_avro(@schema_string, avro_encoded_response)

    decoded_response['protocol'].should == response['protocol']
    decoded_response['status_code'].should == response['status_code']
    decoded_response['status_reason_phrase'].should == response['status_reason_phrase']
    decoded_response['headers'].should == response['headers']
    decoded_response['content'].should == response['content']
  end
end

