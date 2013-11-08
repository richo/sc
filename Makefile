lib/sc/lexer.rb: src/lexer.in.rb
	ragel -R $< -o $@
