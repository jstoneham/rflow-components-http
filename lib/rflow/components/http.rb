require 'rflow/components/http/extensions'
require 'rflow/components/http/server'

class RFlow
  module Components
    module HTTP
      # Load the schemas
      SCHEMA_DIRECTORY = ::File.expand_path(::File.join(::File.dirname(__FILE__), '..', '..', '..', 'schema'))
      
      SCHEMA_FILES = {
        'http_response.avsc' => 'RFlow::Message::Data::HTTP::Response',
        'http_request.avsc'  => 'RFlow::Message::Data::HTTP::Request',
      }
      
      SCHEMA_FILES.each do |file_name, data_type_name|
        schema_string = ::File.read(::File.join(SCHEMA_DIRECTORY, file_name))
        RFlow::Configuration.add_available_data_type data_type_name, 'avro', schema_string
      end

      # Load the data extensions
      RFlow::Configuration.add_available_data_extension('RFlow::Message::Data::HTTP::Request',
                                                        RFlow::Components::HTTP::Extensions::IPConnectionExtension)
      RFlow::Configuration.add_available_data_extension('RFlow::Message::Data::HTTP::Request',
                                                        RFlow::Components::HTTP::Extensions::HTTPRequestExtension)

      
      RFlow::Configuration.add_available_data_extension('RFlow::Message::Data::HTTP::Response',
                                                        RFlow::Components::HTTP::Extensions::IPConnectionExtension)
      RFlow::Configuration.add_available_data_extension('RFlow::Message::Data::HTTP::Response',
                                                        RFlow::Components::HTTP::Extensions::HTTPResponseExtension)

    end
  end
end
