module Roxx
  module Dsl
    class LibraryCommand
      attr_reader :repository

      def initialize library, &block
        @repository = library 
        instance_eval(&block)
      end

      def set name, options = {}
        @repository.set name, options
      end

    end
  end
end
