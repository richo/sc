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

  visibility  = ('inline' | 'public');

  main := |*

    visibility => {
      emit(:visibility, data, token_array, ts, te)
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

class Token
  attr_reader :type, :data

  def initialize(type, data)
    @type = type
    @data = data
  end

  def inspect
    "#{type.inspect} => #{data}"
  end

end

def emit(type, data, target_array, ts, te)
  target_array << Token.new(type, data[ts...te].pack("c*"))
end

class Lexer

%% write data;

end


def Lexer.lex(data)
  data = data.unpack("c*") if(data.is_a?(String))
  eof = data.length
  token_array = []

%% write init;
%% write exec;

  if sc_error != 0
    raise Exception( %%{ write error; }%% );
  end

  token_array
end
