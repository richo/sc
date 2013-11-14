module SC
  module Machines
    class TopLevel < SC::Machine
      def entry(ast)
        loop do
          @tok = _next
          case @tok.type
          when :identifier
            handle_identifier
          else
            raise ParseError.new("Unexpected #{@tok.inspect}")
          end
        end
      end

      def handle_identifier
        # The only valid toplevel identifiers are
        #   inline | public
        # for function visilibity
        #   function
        if @current[:visibility]
          case @tok.data
          when "fn"
            _goto(:fn, @current)
          else
            raise ParseError.new("Unexpected #{@tok.inspect}")
          end
        else
          case @tok.data
          when "inline"
            @current[:visibility] = :inline
          when "public"
            @current[:visibility] = :public
          else
            raise ParseError.new("Unexpected #{@tok.inspect}")
          end
        end
      end

    end
  end
end
