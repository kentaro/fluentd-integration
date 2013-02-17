require_relative '../../../spec_helper'

module Fluentd
  module Integration
    describe Util do
      describe '.empty_port' do
        it {
          expect(Fluentd::Integration::Util.empty_port).to be_an_instance_of(Fixnum)
        }
      end
    end
  end
end
