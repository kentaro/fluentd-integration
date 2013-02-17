#!/usr/bin/env ruby

require_relative '../lib/fluentd/integration'

server1 = Fluentd::Integration::Server.new
server2 = Fluentd::Integration::Server.new(capture_output: true)

server1.conf = <<EOS
<source>
  type forward
  port #{server1.port}
</source>

<match test>
  type forward
  flush_interval 1s # DON'T FORGET THIS

  <server>
    name server1
    host 127.0.0.1
    port #{server2.port}
  </server>
</match>
EOS

server2.conf = <<EOS
<source>
  type forward
  port #{server2.port}
</source>

<match test>
  type stdout
</match>
EOS

server2.start
server1.start

client = Fluentd::Integration::Client.new(port: server1.port)
client.post(:test, { foo: "bar" })

# wait until time (`flush_interval`) passes
sleep 2

puts server2.in.first #=> <time> test: {"foo":"bar"}
