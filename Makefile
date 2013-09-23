tube-lex:	lexer.cpp
	g++ -o tube-lex lexer.cpp -ll
lexer.cpp: proj1.lex
	flex -o lexer.cpp proj1.lex
