
module SC
  module Machines
    class Expression < SC::Machine
      def entry(ast)
        expression = []
        loop do
          tok = _next
          case tok.type
          when :semicolon
            _return expression
          else
            expression << tok
          end
        end
      end

    end
  end
end
