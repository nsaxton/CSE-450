%{
#include <iostream>
#include <fstream>
#include <string>
#include <map>

using namespace std;

extern int line_count;
extern bool hasError = false;

void yyerror(char *err_string)
{
	cerr << "ERROR(line " << line_count << "): syntax error" << endl;
	hasError = true;
}

// Symbol table definition
typedef struct {
	int value;
	int line_number;
} symbol;
map<string, symbol> id_map;

extern int yylex();
extern FILE *yyin;
%}

%union {
	char * lexeme;
	int number;
}

%left '+' '-'
%left '*' '/'

%token <lexeme> ID
%token <number> STATIC_INT
%token TYPE_INT COMMAND PLUS MINUS TIMES DIVIDE MOD ASSIGN ADD_ASSIGN SUB_ASSIGN 
	   MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN OP CP SEPARATOR ENDLINE
%type <number> expr	list

%%

program:	program statement
			| {}

statement:	expr ENDLINE {
				//cout << "Line result: " << $1 << endl;			
			}
			| TYPE_INT ID ENDLINE {
				if(id_map.find($2) != id_map.end())
				{
					cout << "ERROR(line " << line_count << "): re-defining variable '" << $2 << "'" << endl;
					exit(1);
				}
				symbol var = {0, line_count};
				id_map[$2] = var;
			}
			| TYPE_INT ID ASSIGN expr ENDLINE {
				if(id_map.find($2) != id_map.end())
				{
					cout << "ERROR(line " << line_count << "): re-defining variable '" << $2 << "'" << endl;
					exit(1);
				}
				id_map[$2].value = $4;
			}
			| ID ASSIGN expr ENDLINE {
				if(id_map.find($1) == id_map.end())
				{
					cout << "ERROR(line " << line_count << "): unknown variable '" << $1 << "'" << endl;
					exit(1);
				}
				id_map[$1].value = $3;
			}
			| TYPE_INT ID ADD_ASSIGN expr ENDLINE {
				if(id_map.find($2) != id_map.end())
				{
					cout << "ERROR(line " << line_count+1 << "): re-defining variable '" << $2 << "'" << endl;
					exit(1);
				}
				id_map[$2].value += $4;
			}
			| TYPE_INT ID SUB_ASSIGN expr ENDLINE {
				if(id_map.find($2) != id_map.end())
				{
					cout << "ERROR(line " << line_count+1 << "): re-defining variable '" << $2 << "'" << endl;
					exit(1);
				}
				id_map[$2].value -= $4;
			}
			| TYPE_INT ID MULT_ASSIGN expr ENDLINE {
				if(id_map.find($2) != id_map.end())
				{
					cout << "ERROR(line " << line_count+1 << "): re-defining variable '" << $2 << "'" << endl;
					exit(1);
				}
				id_map[$2].value *= $4;
			}
			| TYPE_INT ID DIV_ASSIGN expr ENDLINE {
				if(id_map.find($2) != id_map.end())
				{
					cout << "ERROR(line " << line_count+1 << "): re-defining variable '" << $2 << "'" << endl;
					exit(1);
				}
				id_map[$2].value /= $4;
			}
			| TYPE_INT ID MOD_ASSIGN expr ENDLINE {
				if(id_map.find($2) != id_map.end())
				{
					cout << "ERROR(line " << line_count+1 << "): re-defining variable '" << $2 << "'" << endl;
					exit(1);
				}
				id_map[$2].value %= $4;
			}
			| ID ADD_ASSIGN expr ENDLINE {
				if(id_map.find($1) == id_map.end())
				{
					cout << "ERROR(line " << line_count << "): unknown variable '" << $1 << "'" << endl;
					exit(1);
				}
				id_map[$1].value += $3;
			}
			| ID SUB_ASSIGN expr ENDLINE {
				if(id_map.find($1) == id_map.end())
				{
					cout << "ERROR(line " << line_count << "): unknown variable '" << $1 << "'" << endl;
					exit(1);
				}
				id_map[$1].value -= $3;
			}
			| ID MULT_ASSIGN expr ENDLINE {
				if(id_map.find($1) == id_map.end())
				{
					cout << "ERROR(line " << line_count << "): unknown variable '" << $1 << "'" << endl;
					exit(1);
				}
				id_map[$1].value *= $3;
			}
			| ID DIV_ASSIGN expr ENDLINE {
				if(id_map.find($1) == id_map.end())
				{
					cout << "ERROR(line " << line_count << "): unknown variable '" << $1 << "'" << endl;
					exit(1);
				}
				id_map[$1].value /= $3;
			}
			| ID MOD_ASSIGN expr ENDLINE {
				if(id_map.find($1) == id_map.end())
				{
					cout << "ERROR(line " << line_count << "): unknown variable '" << $1 << "'" << endl;
					exit(1);
				}
				id_map[$1].value %= $3;
			}
			| COMMAND list ENDLINE {}
	
list:		expr SEPARATOR list {}
			| expr {}

expr:		expr PLUS expr { $$ = $1 + $3; }
			| expr MINUS expr { $$ = $1 - $3; }
			| expr TIMES expr { $$ = $1 * $3; }
			| expr DIVIDE expr { $$ = $1 / $3; }
			| expr MOD expr { $$ = $1 % $3; }
			| OP expr CP { $$ = $2; }
			| MINUS expr { $$ = -$2; }
			| ID {
				if(id_map.find($1) == id_map.end())
				{
					cout << "ERROR: variable '" << $1 << "' not defined." << endl;
					exit(1);
				}
				$$ = id_map[$1].value;
			}
			| STATIC_INT { $$ = $1; };

%%

main(int argc, const char * argv[] ) 
{ 
	// Check for correct number of arguments:
	if (argc != 2)
	{
		cerr << "Format: " << argv[0] << " [source filename]" << endl;
		exit(1);
	}
   	// Open a file handle to the file:
	FILE *myfile = fopen(argv[1], "r");
	// Make sure it is valid:
	if (!myfile) {
		cerr << "Error: Unable to open file '" << argv[1] << "' Halting." << endl;
		exit(2);
	}
	// Set flex to read from the file:
	yyin = myfile;
	
	// Parse through the input until there is no more:
	do {
		yyparse();
		if(hasError)
			exit(1);
	} while (!feof(yyin)); 
	
	cout << "Parse Successful!" << endl;
}
