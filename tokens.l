%{
#include <string>
#include "node.h"
#include "parser.hpp"

#define SAVE_TOKEN  yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t)    (yylval.token = t)
%}

%option noyywrap

%%

[ \t\n]					        ;
"extern"                        return TOKEN(TEXTERN);
"return"				        return TOKEN(TRETURN);
"if"                            return TOKEN(TIF);
"else"                          return TOKEN(TELSE);
"while"                         return TOKEN(TWHILE);
\'.\'|\'\\.\'                   SAVE_TOKEN; return TCHAR;
\"(\\.|[^"\\])*\"               SAVE_TOKEN; return TSTRING;
[a-zA-Z_][a-zA-Z0-9_]*  SAVE_TOKEN; return TIDENTIFIER;
[0-9]+\.[0-9]* 			    SAVE_TOKEN; return TDOUBLE;
[0-9]+					        SAVE_TOKEN; return TINTEGER;

"="						          return TOKEN(TEQUAL);
"=="				          	return TOKEN(TCEQ);
"!="			          		return TOKEN(TCNE);
"<"				          		return TOKEN(TCLT);
"<="	          				return TOKEN(TCLE);
">"				          		return TOKEN(TCGT);
">="					          return TOKEN(TCGE);

"("	          					return TOKEN(TLPAREN);
")"					          	return TOKEN(TRPAREN);
"{"         						return TOKEN(TLBRACE);
"}"					          	return TOKEN(TRBRACE);

"."         						return TOKEN(TDOT);
","				          		return TOKEN(TCOMMA);

"+"				          		return TOKEN(TPLUS);
"-"		          				return TOKEN(TMINUS);
"*"		          				return TOKEN(TMUL);
"/"				          		return TOKEN(TDIV);
"%"                             return TOKEN(TMOD);

"&"                             return TOKEN(TGETADDR);

"["                             return TOKEN(TLBRACKET);
"]"                             return TOKEN(TRBRACKET); 

"&&"                            return TOKEN(TAND);
"||"                            return TOKEN(TOR);

.                       printf("Unknown token!\n"); yyterminate();

%%
