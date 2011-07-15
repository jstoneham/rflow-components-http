class RFlow
  module Components
    module HTTP

      # The set of extensions to add capability to HTTP data types
      module Extensions

        module IPConnectionExtension
          # Default accessors
          # TODO: validate the stuffs
          ['client_ip', 'client_port', 'server_ip', 'server_port'].each do |name|
            define_method name do |*args|
              data_object[name]
            end
            define_method :"#{name}=" do |*args|
              data_object[name] = args.first
            end
          end
        end
        
        # Need to be careful when extending to not clobber data already in data_object
        module HTTPRequestExtension
          def self.extended(base_data)
            base_data.data_object ||= {'uri' => '/', 'method' => 'GET', 'protocol' => 'HTTP/1.0', 'headers'=>{}, 'content' => ''}
          end

          # Default accessors
          ['method', 'uri', 'query_string', 'protocol', 'headers', 'content'].each do |name|
            define_method name do |*args|
              data_object[name]
            end
            define_method :"#{name}=" do |*args|
              data_object[name] = args.first
            end
          end
        end
        
        # Need to be careful when extending to not clobber data already in data_object
        module HTTPResponseExtension
          def self.extended(base_data)
            base_data.data_object ||= {'protocol' => 'HTTP/1.0', 'status_code' => 200, 'status_reason_phrase' => 'OK', 'headers' => {}, 'content' => ''}
          end

          # Default accessors
          ['protocol', 'status_reason_phrase', 'headers', 'content'].each do |name|
            define_method name do |*args|
              data_object[name]
            end
            define_method :"#{name}=" do |*args|
              data_object[name] = args.first
            end
          end

          ['status_code'].each do |name|
            define_method name do |*args|
              data_object[name]
            end
            define_method :"#{name}=" do |*args|
              data_object[name] = args.first.to_i
            end
          end
          
        end

      end
    end
  end
end
