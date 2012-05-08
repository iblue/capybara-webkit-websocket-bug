require 'spec_helper'

# See also the JS in app/views/welcome/index.html.erb

describe 'the bug', :js => true do
  # Start a local websocket
  before :all do
    @websocket_server = Process.fork do
      class TestServer < EM::WebSocket::Server
        def on_connect
          #
          # Description of the problem:
          #
          # QtWebkit sends WebSocket-Protocol: "myprocotol". This is deprecated. The header
          # should be Sec-WebSocket-Protocol according to RFC 6455. http://tools.ietf.org/html/rfc6455
          #
          # This leads to problems for all websocket implementations, including em-websocket-server,
          # jetty and probably em-websocket (untested). 
          if request.protocol == "myprotocol"
            send_message "pass" 
          else
            send_message "websocket-broken"
          end

          # The support for RFC 6455 seems to be included in more recent versions. So in order to make
          # this work, you just need to upgrade Qt Webkit.
          #
          # See also https://bugs.webkit.org/show_bug.cgi?id=85737
        end
      end

      EM.run do
        EM.start_server "127.0.0.1", "8888", TestServer
      end
    end
    sleep 2 # Wait for the server to start
  end

  after :all do
    Process.kill(9, @websocket_server)
  end

  it 'has problems with websocket protocol' do
    visit '/'
    page.find('#websocket-content').text.should == 'pass'
  end
end

