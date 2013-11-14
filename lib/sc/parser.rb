require 'sc/ast'
require 'sc/machine'
require 'sc/machines/all'

require 'sc/types/all'

GLOBALS = {}

module SC
  class ControlFlow < Exception
    attr_reader :name, :data
    def initialize(name, data)
      @name = name
      @data = data
    end
  end
  class Goto < ControlFlow
  end
  class Return < ControlFlow
  end

  class ParseError < Exception
  end

  class Parser
    DEFAULT_MACHINE = Machines::TopLevel
    MACHINES = {
        nil => DEFAULT_MACHINE,
        :fn => Machines::Fn,
        :fn_body => Machines::FnBody,
        :expression => Machines::Expression
      }


    def initialize(tokens)
      @tokens = tokens
      @ast = AST.new
    end

    def parse
      to = nil
      data = nil
      until @tokens.empty? do
        begin
          MACHINES[to].new(@tokens).enter(@ast, data)

          # Reset to if no goto was raised.
          to = nil
        rescue Goto => e
          to = e.name
          data = e.data
        rescue Return => e
          to = e.name
          data = e.data
        end
      end
      @ast
    end

  end
end
