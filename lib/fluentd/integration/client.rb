require 'json'

module Fluentd
  module Integration
    class Client
      attr_accessor :command, :port, :host, :format

      def initialize(args = {})
        @command = args[:command] || 'fluent-cat'
        @port    = args[:port]    || 24224
        @host    = args[:host]    || '127.0.0.1'
        @format  = args[:format]  || 'json'
        @tag     = args[:tag]     || 'debug.test'
      end

      def post(tag, message)
        %x{
          echo '#{JSON.dump(message)}' |
          #{command} -p #{port.to_s} -h #{host} -f #{format} #{tag}
        }
        $?
      end
    end
  end
end
