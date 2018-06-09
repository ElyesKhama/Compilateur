%{
	#include "compiler.tab.h"
%}

Lettre [a-zA-Z]
Chiffre [0-9]
%%




"if"						{yylval.str = strdup(yytext); return IF;}
"while"						{yylval.str = strdup(yytext); return WHILE;}
"else"						{yylval.str = strdup(yytext); return ELSE;}
";"							{return PV;}
"printf"				 	{return PRINTF;}
"main"						{yylval.str = strdup(yytext); return MAIN;}
"{"							{return OA; }
"}"							{return CA;}
"const"						{return CONST;}
"void" 						{ yylval.str = strdup(yytext); return VOID;}
"return"					{ yylval.str = strdup(yytext); return RETURN;}
"int"						{ yylval.str = strdup(yytext); return INT;}
{Lettre}+[a-zA-Z0-9\_]* 	{ yylval.str = strdup(yytext) ; return NOM;}
"+" 						{return PLUS;}
"-"							{return MOINS;}
"*"							{return MUL;}
"/"							{return DIV;}	
"=" 						{return EGALE;}
"<"							{return INF;}
">"							{return SUP;}
"("							{return OP;}	
")"						    {return CP;}

"\""						{return QUOTE;}
"%d"                        {return INT_PRINTF;}
"%s"  						{return STRING_PRINTF;}
"%f"						{return FLOAT_PRINTF;}
","							{return VIR;}
[0-9]+(e-?[0-9]+)?			{yylval.nb = atoi(yytext); return NB;}
[ \t\n]
%%


