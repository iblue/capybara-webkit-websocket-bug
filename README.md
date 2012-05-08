== Demo of a bug in capybara-webkit

The implementation if WebSockets in capybara-webkit seems to be buggy. It still uses an old draft
of the WebSocket implementation that seems to be broken. In order to reproduce the issue, just
clone this repository, <tt>bundle installk</tt> and <tt>rake spec</tt>.

The probleme here is, that it sends a `WebSocket-Protocol` header instead of the expected RFC 6455
`Sec-WebSocket-Protocol` header. It also terminates the connection, if does not receive the same
headers as sent, which is even incorrect according to the drafts I found.

A possible solution would be upgrading to a more recent version of Qt Webkit. But I am not
sure how all the internals of capybara-webkit work, so I will just give you this bug report.

To examine the details, please see
* <tt>spec/integration/websocket_spec.rb</tt>
* <tt>app/views/welcome/index.html.erb</tt>
* https://bugs.webkit.org/show_bug.cgi?id=85737


