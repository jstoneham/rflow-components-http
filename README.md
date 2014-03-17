# RFlow-Components-HTTP

[![Build Status](https://travis-ci.org/redjack/rflow-components-http.png?branch=master)](https://travis-ci.org/redjack/rflow-components-http)

A gem containing HTTP-specific components and data types for RFlow
(https://github.com/redjack/rflow).

## Data Types

* `RFlow::Message::Data::HTTP::Response` - an HTTP request RFlow message
* `RFlow::Message::Data::HTTP::Request` - an HTTP response RFlow message

## Server

The server component (`RFlow::Components::HTTP::Server`) implements a
HTTP server based on
[`eventmachine_httpserver`](https://github.com/eventmachine/evma_httpserver).
The component accepts incoming HTTP connections (according to its
configuration, see below), marshals the HTTP request into an RFlow
message, annotates the message with a bit of provenance (see below)
and then sends the message out its `request_port`.  When a HTTP
response message is received on its `response_port`, the component
checks the provenance to see if it matches an underlying TCP/HTTP
connection and, if so, creates an actual HTTP response from the
incoming message and send it to the client.

The HTTP request message sent from the HTTP server component utilizes
the `RFlow::Message` provenance feature to annotate a request message
with a bit of metadata that allows subsequent response messages to be
matched to their underlying TCP/HTTP connections.  This means that any
component that processes HTTP request messages to generate response
messages *must copy the provenance from the request message to the
response message*.

### Configuration

* `listen` - the IP address on which to listen, defaults to '127.0.0.1'
* `port` - the port on which to listen, defaults to '8000'

### Examples

### Limitations

The underlying eventmachine_httpserver has two limitations that we've
run across:

* Max 20 MB HTTP request Content-Length:
  https://github.com/eventmachine/evma_httpserver/blob/master/ext/http.h#L78

* No support for HTTP chunked transfer encoding, mostly because it
  does not sent a Content-Length HTTP header.


## Client

Not yet implemented completely


## License

   Copyright 2014 RedJack LLC

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
