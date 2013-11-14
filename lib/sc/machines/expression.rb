
module SC
  module Machines
    class Expression < SC::Machine

      EXPRS = {
        :push => [[:keyword, "push"], [:integer, nil]]
      }

      def entry(ast)
        expression = []
        loop do
          tok = _next
          case tok.type
          when :semicolon
            parsed_expr = parse(expression)
            _return parsed_expr
          else
            expression << tok
          end
        end
      end

      def parse(expr)
        case expr[0].type
        when :identifier
          handle_identifier(expr)
        end
      end

      def handle_identifier(expr)
        case expr[0].data
          # Handle builtins
        when "push"
          [ :push, expr[1] ]
        when "pop"
          [ :pop, expr[1] ]
        when "echo"
          [ :pop, expr[1] ]
        when "call"
          if expr[1].type != :identifier
            raise ParseError.new("Unexpected #{expr[1].inspect} : Expected identifier")
          end
          handle_call(expr)
        else
          raise ParseError.new("Unexpected #{expr[0]}")
        end
      end

      def handle_call(expr)
        _ = expr.shift # Pull call off the start
        if expr[1].type != :oparen
          raise ParseError.new("Unexpected #{expr[1].inspect} : Expected (")
        end
        name = expr.shift # Pull the name off the start
        _ = expr.shift # Pull oparen off the start
        if expr[-1].type != :cparen
          raise ParseError.new("Unexpected #{expr[-1].inspect} : Expected )")
        end
        _ = expr.pop # nuke the cparen

        [:call, name, [expr]]
      end

    end
  end
end
