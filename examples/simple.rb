#!/usr/bin/env ruby

require_relative '../lib/fluentd/integration'

server = Fluentd::Integration::Server.new(capture_output: true)
server.conf = <<EOS
<source>
  type forward
  port #{server.port}
</source>

<match test>
  type stdout
</match>
EOS
server.start

client = Fluentd::Integration::Client.new(port: server.port)
client.post(:test, { foo: "bar" })

puts server.in.gets #=> <time> test: {"foo":"bar"}
