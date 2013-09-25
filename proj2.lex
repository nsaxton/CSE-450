%{
#include <string.h>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include "proj2.tab.hh"

using namespace std;

int line_count = 1;
%}

%%

[ \t]* 						;	// Ignore whitespace
"int"						{ return TYPE_INT; }
"print" 					{ return COMMAND; }
[_a-zA-Z][_a-zA-Z0-9]*		{ yylval.lexeme = strdup(yytext);
				  			  return ID; }
[0-9]+						{ yylval.number = atoi(yytext);
						      return STATIC_INT; }
"+"							{ return PLUS; }
"-"							{ return MINUS; }
"*"							{ return TIMES; }
"/"							{ return DIVIDE; }
"%"							{ return MOD; }
"="							{ return ASSIGN; }
"+="						{ return ADD_ASSIGN; }
"-="						{ return SUB_ASSIGN; }
"*="						{ return MULT_ASSIGN; }
"/="						{ return DIV_ASSIGN; }
"%="						{ return MOD_ASSIGN; }
"("							{ return OP; }
")"							{ return CP; }
,							{ return SEPARATOR; }
;							{ return ENDLINE; }
#.*							;	// Ignore comments
\n							{ line_count++; }
.							{ return yytext[0]; }

%%
