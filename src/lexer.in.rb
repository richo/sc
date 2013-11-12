=begin
%%{

  machine sc;

  integer     = ('+'|'-')?[0-9]+;
  # float       = ('+'|'-')?[0-9]+'.'[0-9]+;
  assignment  = '=';
  identifier  = [a-zA-Z][a-zA-Z_]+;
  obrace      = '{';
  cbrace      = '}';
  oparen      = '(';
  cparen      = ')';
  dq_string   = '"' ( [^"\\] | /\\./ )* '"';
  semicolon   = ';';

  group       = '(' @{ fcall group_rest; };
  group_rest := ([xo] | group)* ')' @{ fret; };


  inline_fn   = 'inline' space 'fn';
  public_fn   = 'public' space 'fn';

  action oops { raise "Oops" }

  fn1 := |*
    identifier => {
      @current_func.name = Function.get_name(data, ts, te)
    };

    obrace {
      fgoto fn2;
    };

    space {};

    any {
      asplode(data, ts, te)
    };
  *|;

  fn2 := |*
    cbrace {

      token_array << @current_func
      @current_func = nil

      fgoto main;
    };

    any {
      asplode(data, ts, te)
    };
  *|;

  main := |*

    inline_fn {
      emit(:inline_fn, data, token_array, ts, te)
      @current_func = Function.new(:inline)
      fgoto fn1;
    };

    integer => {
      emit(:integer_literal, data, token_array, ts, te)
    };

    # float => {
    #   emit(:float_literal, data, token_array, ts, te)
    # };

    assignment => {
      emit(:assignment_operator, data, token_array, ts, te)
    };

    identifier => {
      emit(:identifier, data, token_array, ts, te)
    };

    oparen => {
      emit(:oparen, data, token_array, ts, te)
    };

    cparen => {
      emit(:cparen, data, token_array, ts, te)
    };

    obrace => {
      emit(:obrace, data, token_array, ts, te)
    };

    cbrace => {
      emit(:cbrace, data, token_array, ts, te)
    };

    dq_string => {
      emit(:string, data, token_array, ts, te)
    };

    semicolon => {
      emit(:semicolon, data, token_array, ts, te)
    };

    space;

  *|;

}%%
=end

class Function
  attr_accessor :name, :args
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def self.get_name(data, ts, te)
    data[ts...te].pack("c*")
  end

end

def new_function!
  @current_function = Function.new()
end

def current_function
  @current_function
end

def emit(token_name, data, target_array, ts, te)
  target_array << {:name => token_name.to_sym, :value => data[ts...te].pack("c*") }
end


class Lexer

%% write data;

end

def asplode(data, ts, te)
  raise data[ts...te].pack("c*")
end

def Lexer.lex(data)
  data = data.unpack("c*") if(data.is_a?(String))
  eof = data.length
  @functions = {}
  token_array = []

%% write init;
%% write exec;

  if sc_error != 0
    raise Exception( %%{ write error; }%% );
  end

  token_array
end
