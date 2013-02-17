require_relative '../../../spec_helper'
require 'tempfile'

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

      describe '#generate_conf_file' do
        context 'when conf is a string' do
          let(:server) { Fluentd::Integration::Server.new }
          let(:conf)   {
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

        context 'when conf is an IO object' do
          let(:server) { Fluentd::Integration::Server.new }
          let(:file)   { Tempfile.new('test') }
          let(:conf)   {
            conf = <<-EOS
<source>
  type forward
  port #{server.port}
</source>
EOS
            file.puts(conf)
            file.close
            File.open(file.path)
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

      describe '#read' do
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
          client.post('integration.test', foo: 'bar')
        }

        it {
          expect(
            server.in.each_line.first =~ /integration\.test/
          ).to be_true
        }
      end
    end
  end
end
