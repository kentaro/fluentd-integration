require "glint"
require "tempfile"

module Fluentd
  module Integration
    class Server
      attr_accessor :command, :fluentd, :conf, :conf_file

      def initialize(args = {})
        @command = args[:command] || 'fluentd'
        @fluentd = Glint::Server.new do
          begin
            exec command, '-c', conf_file.path
          rescue Errno::ENOENT => error
            STDERR.write(error.message)
          end
        end

        def port
          fluentd.port
        end

        def start
          generate_conf_file
          fluentd.start
        end

        def generate_conf_file
          self.conf_file = Tempfile.new('fluentd-integration')

          if conf.kind_of?(IO)
            self.conf = conf.read
          end

          begin
            conf_file.puts(conf)
          ensure
            conf_file.close
          end
        end
      end
    end
  end
end
