require 'rflow'
require 'rflow/components/http/server'

# Load the schemas
module RFlow::Components::HTTP
  SCHEMA_DIRECTORY = File.expand_path(File.join(File.dirname(__FILE__), '..', 'schema'))
  
  SCHEMA_FILES = {
    'http_response.avsc' => 'RFlow::Message::Data::HTTP::Response',
    'http_request.avsc'  => 'RFlow::Message::Data::HTTP::Request',
  }
  
  SCHEMA_FILES.each do |file_name, data_type_name|
    schema_string = File.read(File.join(SCHEMA_DIRECTORY, file_name))
    RFlow::Configuration.add_available_data_type data_type_name, 'avro', schema_string
  end

end
