require_relative '../../../spec_helper'

module Fluentd
  module Integration
    describe Server do
      describe '.new' do
        let(:server) { Fluentd::Integration::Server.new }

        it {
          expect(server.port).to be_an_instance_of(Fixnum)
        }
      end

      describe '#start' do
        let(:server) { Fluentd::Integration::Server.new }
        let(:conf)    {
          <<-EOS
<source>
  type forward
  port #{server.port}
</source>
EOS
        }
        before {
          server.conf = conf
          server.start
        }

        it {
          expect {
            TCPSocket.open('127.0.0.1', server.port)
          }.to_not raise_error
        }
      end
    end
  end
end
