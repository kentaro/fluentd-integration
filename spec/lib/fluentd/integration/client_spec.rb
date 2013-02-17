require_relative '../../../spec_helper'

module Fluentd
  module Integration
    describe Client do
      describe '.new' do
        let(:client) { Fluentd::Integration::Client.new }

        it {
          expect(client.port).to be_an_instance_of(Fixnum)
        }
      end

      describe '#post' do
        let(:server) { Fluentd::Integration::Server.new(capture_output: true) }
        let(:conf)    {
          <<-EOS
<source>
  type forward
  port #{server.port}
</source>

<match integration.test>
  type stdout
</match>
EOS
        }
        let(:client) { Fluentd::Integration::Client.new(port: server.port) }

        before {
          server.conf = conf
          server.start
        }

        it {
          expect(client.post('integration.test', foo: 'bar').success?).to be_true
        }
      end
    end
  end
end
