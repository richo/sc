module SC
  module Types
    class Function
      attr_reader :name, :visibility, :expressions
      def initialize(name, visibility, expressions)
        @name = name
        @visibility = visibility
        @expressions = expressions
      end
    end
  end
end
