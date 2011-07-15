require 'eventmachine'
require 'evma_httpserver'

require 'rflow'

class RFlow
  module Components
    module HTTP

      class Server < RFlow::Component
        input_port :response_port
        output_port :request_port
        
        attr_accessor :port, :listen, :server_signature, :connections
        
        def configure!(config)
          @listen = config['listen'] ? config['listen'] : '127.0.0.1'
          @port = config['port'] ? config['port'].to_i : 8000
          @connections = Hash.new
        end

        def run!
          @server_signature = EM.start_server(@listen, @port, Connection) do |conn|
            conn.server = self
            self.connections[conn.signature.to_s] = conn
          end
        end

        # Getting all messages to response_port, which we need to filter for
        # those that pertain to this component and have active connections.
        # This is done by inspecting the provenance, specifically the
        # context attribute that we stored originally
        def process_message(input_port, input_port_key, connection, message)
          RFlow.logger.debug "Received a message"
          return unless message.data_type_name == 'RFlow::Message::Data::HTTP::Response'

          
          RFlow.logger.debug "Received a HTTP::Response message, determining if its mine"
          my_events = message.provenance.find_all {|processing_event| processing_event.component_instance_uuid == instance_uuid}
          RFlow.logger.debug "Found #{my_events.size} processing events from me"
          # Attempt to send the data to each context match
          my_events.each do |processing_event|
            RFlow.logger.debug "Inspecting #{processing_event.context}"
            connection_signature = processing_event.context
            if connections[connection_signature]
              RFlow.logger.debug "Found connection for #{processing_event.context}"
              connections[connection_signature].send_http_response message
            end
          end
        end
        
        class Connection < EventMachine::Connection
          include EventMachine::HttpServer

          attr_accessor :server
          attr_reader :client_ip, :client_port, :server_ip, :server_port

          def post_init
            @client_port, @client_ip = Socket.unpack_sockaddr_in(get_peername) rescue ["?", "?.?.?.?"]
            @server_port, @server_ip = Socket.unpack_sockaddr_in(get_sockname) rescue ["?", "?.?.?.?"]
            RFlow.logger.debug "Connection from #{@client_ip}:#{@client_port} to #{@server_ip}:#{@server_port}"
            super
            no_environment_strings
          end

          
          def receive_data(data)
            RFlow.logger.debug "Received #{data.bytesize} bytes of data from #{client_ip}:#{client_port} to #{@server_ip}:#{@server_port}"
            super
          end
          
          
          def process_http_request
            RFlow.logger.debug "Received a HTTP request from #{client_ip}:#{client_port} to #{@server_ip}:#{@server_port}"
            
            processing_event = RFlow::Message::ProcessingEvent.new(server.instance_uuid, Time.now.utc)

            request_message = RFlow::Message.new('RFlow::Message::Data::HTTP::Request')
            request_message.data.uri = @http_request_uri

            processing_event.context = signature
            processing_event.completed_at = Time.now.utc
            request_message.provenance << processing_event

            server.request_port.send_message request_message
          end

          
          def send_http_response(response_message=nil)
            RFlow.logger.debug "Sending an HTTP response to #{client_ip}:#{client_port}"
            resp = EventMachine::DelegatedHttpResponse.new(self)

            # Default values
            resp.status                  = 200
            resp.content                 = ""
            resp.headers["Content-Type"] = "text/html"
            resp.headers["Server"]       = "Apache"
            
            if response_message
              resp.status  = response_message.data.status_code
              resp.content = response_message.data.content
              response_message.data.headers.each do |header, value|
                resp[headers] = value
              end
            end

            resp.send_response
            close_connection_after_writing
          end

          
          # Called when a connection is torn down for whatever reason.
          # Remove this connection from the server's list
          def unbind(reason=nil)
            RFlow.logger.debug "Disconnected from HTTP client #{client_ip}:#{client_port} due to '#{reason}'"
            server.connections.delete(self.signature)
          end
        end
      end

    end
  end
end
