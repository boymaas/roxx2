module Roxx
  module Dsl
    class LibraryCommand
      def initialize library, &block
        @library = library 
        instance_eval(&block)
      end

      def set name, options = {}
        @library.set name, options
      end
    end
  end
end
