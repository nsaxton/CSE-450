%{
#include <iostream>
#include <fstream>
#include <string>
#include "symbol_table.h"

using namespace std;

void yyerror(char * err_string)
{
	cerr << "Input match failed!" << endl;
}

extern int yylex();
extern int line_count;
extern FILE * yyin;

symbol_table symbols;
%}

%union {
	char * lexeme;
	int number;
}

%left '+' '-'
%left '*' '/'

%token <lexeme> ID
%token <number> STATIC_INT
%token TYPE_INT COMMAND PLUS MINUS TIMES DIVIDE MOD ASSIGN ADD_ASSIGN SUB_ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN OP CP SEPARATOR ENDLINE
%type <number> expr	list

%%

program:	program statement
					| {}

statement:	expr ENDLINE {}
					|	TYPE_INT ID ENDLINE {
							if(symbols.getSymbol($2))
							{
								cout << "ERROR: variable '" << $2 << "' already defined." << endl;
								exit(1);
							}
							symbols.insert($2, 0, line_number);
						}
					|	TYPE_INT ID ASSIGN expr ENDLINE {
							if(symbols.getSymbol($2))
							{
								cout << "ERROR: variable '" << $2 << "' already defined." << endl;
								exit(1);
							}
							symbols.assign($2, $4);
						}
					|	ID ASSIGN expr ENDLINE {
							if(!symbols.getSymbol($1))
							{
								cout << "ERROR: variable '" << $1 << "' not defined." << endl;
							}
							symbols.assign($1, $3);
						}
					| TYPE_INT ID ADD_ASSIGN expr ENDLINE {}
					| TYPE_INT ID SUB_ASSIGN expr ENDLINE {}
					| TYPE_INT ID MULT_ASSIGN expr ENDLINE {}
					| TYPE_INT ID DIV_ASSIGN expr ENDLINE {}
					| TYPE_INT ID MOD_ASSIGN expr ENDLINE {}
					| ID ADD_ASSIGN expr ENDLINE {}
					| ID SUB_ASSIGN expr ENDLINE {}
					| ID MULT_ASSIGN expr ENDLINE {}
					| ID DIV_ASSIGN expr ENDLINE {}
					| ID MOD_ASSIGN expr ENDLINE {}
					| COMMAND list ENDLINE {}
	
list:				expr SEPARATOR list {}
					| expr {}

expr:				expr PLUS expr { $$ = $1 + $3; }
					|	expr MINUS expr { $$ = $1 - $3; }
					| expr TIMES expr { $$ = $1 * $3; }
					| expr DIVIDE expr { $$ = $1 / $3; }
					| expr MOD expr { $$ = $1 % $3; }
					| OP expr CP { $$ = $2; }
					| MINUS expr { $$ = -$2; }
					|	ID {
							if(!symbols.getSymbol($1))
							{
								cout << "ERROR: variable '" << $1 << "' not defined." << endl;
								exit(1);
							}
							$$ = symbols.getSymbol($1);
						}
					| STATIC_INT { $$ = $1; };

%%

main(int argc, const char * argv[] ) 
{ 
   if(argc != 2)
   {
     cerr << "Format: " << argv[0] << " [source filename]" << endl;
   }
 
	 FILE * sfile = fopen(argv[1],"r");
   if(sfile == NULL)
   {
    cerr << "Error: Unable to open '" << argv[1] << "'. Halting." << endl;
   }
	 yyin = sfile; 
   yyparse(); 
}
