NeoConsoleTelnetServer offers a command line interface to a Pharo image over a network connection.

Inspect:

  NeoConsoleTelnetServer new start.

In a terminal do:

  $ telnet localhost 4999

End with quit or an empty line.

Security warning: this service opens up your image for access to those with access to your local network (i.e. those logged in to your machine), without any further authenication, allowing them to do absolutely anything. Think and make sure that you know what you are doing.