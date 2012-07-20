require 'spec_helper'

describe RFlow::Components::HTTP::Server do

  it "should do stuff" do
    c = RFlow::Components::HTTP::Server::Connection.new('a')
    m = RFlow::Message.new("RFlow::Message::Data::HTTP::Response")
    m.data.headers['Boom'] = 'Town'
    c.send_http_response(m)
  end
end
