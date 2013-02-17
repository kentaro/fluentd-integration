require "glint"
require "tempfile"

module Fluentd
  module Integration
    class Server
      attr_accessor :command, :fluentd, :conf, :conf_file, :in, :out, :capture_output

      def initialize(args = {})
        @command = args[:command] || 'fluentd'
        @capture_output = args[:capture_output]

        if capture_output
          self.in, self.out = IO.pipe
        end

        @fluentd = Glint::Server.new do
          begin
            if capture_output
              self.in.close
              $stdout.reopen(out)
            end

            command_args = ['-c', conf_file.path]

            unless args[:verbose]
              command_args << '-q'
            end

            exec command, *command_args
          rescue Errno::ENOENT => error
            STDERR.write(error.message)
          end
        end
      end

      def port
        fluentd.port
      end

      def start
        generate_conf_file
        fluentd.start

        if capture_output
          out.close
        end
      end

      def generate_conf_file
        # XXX
        self.conf_file = Tempfile.new([rand**32, '.conf'])

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
