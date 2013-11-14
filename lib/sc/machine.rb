# Hilariously ghetto state machines because I couldn't work out how to make
# ragel accept arrays of ruby symbols as inputs
module SC
  class Machine
    def initialize(tokens)
      @tokens = tokens
      @current = {}
    end

    def enter(ast, data)
      @data = data
      entry(ast)
    end

    def entry(ast)
      raise NotImplementedError
    end

    def _next
      @tokens.shift
    end

    def _peek
      @tokens[0]
    end

    def _return(data = nil)
      raise Return.new(nil, data)
    end

    def _goto(name, data = nil)
      raise Goto.new(name, data)
    end

    def _call(name, data = nil)
      begin
        Parser::MACHINES[name].new(@tokens).enter(@ast, data)
        raise "Unexited machine"
      rescue Return => e
        e.data
      end
    end

  end
end
