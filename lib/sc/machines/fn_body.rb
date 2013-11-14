module SC
  module Machines
    class FnBody < SC::Machine
      def entry(ast)
        @data[:expressions] = []
        loop do
          @tok = _peek
          case @tok.type
          when :cbrace
            _next
            fn = Types::Function.new(@data[:name], @data[:visibility], @data[:expressions])
            ast << fn
            _return
          else
            expression = _call(:expression)
            @data[:expressions] << expression
          end
        end
      end

    end
  end
end
