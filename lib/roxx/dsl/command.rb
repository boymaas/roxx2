module Roxx
  module Dsl
    class Command
      def perform &block
        instance_eval(&block)
      end

      def raise_argument_condition_when boolean, opts = {}
        message = opts.fetch(:and_display)
        raise ArgumentError, message if boolean
      end
    end
  end
end
