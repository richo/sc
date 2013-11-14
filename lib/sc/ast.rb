module SC
  class AST
    def data
      @data ||= []
    end

    def << o
      data << o
    end
  end
end
