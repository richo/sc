module SC
  module Machines
    class Fn < SC::Machine
      def entry(ast)
        get_name
        get_brace
      end

      def get_name
        tok = _next
        case tok.type
        when :identifier
          @data[:name] = tok.data
        else
          raise ParseError.new("Unexpected #{@tok.inspect}")
        end
      end

      def get_brace
        tok = _next
        case tok.type
        when :obrace
          _goto(:fn_body, @data)
        else
          raise ParseError.new("Unexpected #{@tok.inspect}")
        end
      end

    end
  end
end
