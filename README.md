# Fluentd::Integration [![BuildStatus](https://secure.travis-ci.org/kentaro/fluentd-integration.png)](http://travis-ci.org/kentaro/fluentd-integration)

Fluentd::Integration provides some utilities that help you to test your configurations through the whole fluentd processes.

## Usage

### Test against a Process

```ruby
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
```

### Test against Multiple Process

```ruby
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
```

## Installation

Add this line to your application's Gemfile:

    gem 'fluentd-integration'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluentd-integration

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
