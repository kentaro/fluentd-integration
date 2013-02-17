require 'glint'

module Fluentd
  module Integration
    module Util
      def self.empty_port
        Glint::Util.empty_port
      end
    end
  end
end
