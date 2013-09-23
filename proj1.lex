%{
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int line_count = 0;
%}

%option c++ noyywrap

WHITESPACE	[ \t]*
TYPE				int
COMMAND			print
ID					[_a-zA-Z][_a-zA-Z0-9]*
STATIC_INT	[0-9]+
OPERATOR		[+\-*/%\(\)=]
COMPOUND		[+\-*/%][=]
SEPARATOR		,
ENDLINE			;
COMMENT			#.*
EOL					\n
UNKNOWN			.

%%

{WHITESPACE} /* Ignore whitespace */;
{COMMAND} { cout << "COMMAND: " << yytext << endl; }
{TYPE} { cout << "TYPE: " << yytext << endl; }
{ID} { cout << "ID: " << yytext << endl; }
{STATIC_INT} { cout << "STATIC_INT: " << yytext << endl; }
{SEPARATOR} { cout << "SEPARATOR: " << yytext << endl; }
{ENDLINE} { cout << "ENDLINE: " << yytext << endl; }
{OPERATOR} { cout << "OPERATOR: " << yytext << endl; }
{COMPOUND} { cout << "OPERATOR: " << yytext << endl; }
{COMMENT} /* Ignore comments */;
{EOL} { ++line_count; }
{UNKNOWN} { cout << "UNKNOWN: " << yytext << endl; exit(1); }

%%

main(int argc, char * argv[])
{
	// Process inputs
	if (argc != 2) {
		cerr << "Format: " << argv[0] << " [source filename]" << endl;
		exit(1);
	}
	// Open the file
	ifstream sfile(argv[1]);

	if (sfile.fail()) {
		cerr << "Error: Unable to open file '" << argv[1] << "'. Halting." << endl;
		exit(2);
	}

	FlexLexer* lexer = new yyFlexLexer(&sfile);
	while (lexer->yylex());
	cout << "Line count: " << line_count << endl;

	return 0;
}
