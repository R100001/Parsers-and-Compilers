/*
A simple syntax analyser for a mini language:
Lexical Analysis File
File contains a simple Lexical Analyser
I. Sakellariou 2017 (based on simple examples from other authors)

*/

%{
#include <stdlib.h>
#include <string.h>

//int line = 1;
%}

%option yylineno

/* Regular Definitions: These are shorthands for expression and can be used in the
rule part below. ATTENTION: When using them in a rule  place the in curtly brackets "{" "}" ! */
POSINT	[0-9]|[1-9][0-9]*
INT 	(-)?{POSINT}
DIGITS 	([0-9])+
FRAC 	\.{DIGITS}
EXP 	[eE](-|\+)?{DIGITS}
NUMBER 	{INT}|{INT}{FRAC}|{INT}{EXP}|{INT}{FRAC}{EXP}

/*New line definition that can handle both UNIX and DOS files. */
newline \n|\x0A|\x0D\x0A


%%

"int"		{yylval.entity.type = type_integer; return T_type;}
"float"		{yylval.entity.type = type_real; return T_type;}
"string"	{yylval.entity.type = type_string; return T_type;}
"object"	{yylval.entity.type = type_object; return T_type;}
"const"		{yylval.entity.type = type_constant; return T_type;}
"array"		{yylval.entity.type = type_array; return T_type;}

"true" 		{return T_true;}
"false" 	{return T_false;}
"null" 		{return T_null;}

")" 		{return ')';}
"(" 		{return '(';}
"{" 		{return '{';} /* See comment (1) Below */
"}" 		{return '}';}
":" 		{return ':';}
"," 		{return ',';}
"[" 		{return '[';}
"]" 		{return ']';}

{INT}   	{yylval.num = atoi(yytext); return T_number_int;}
{NUMBER} 	{yylval.numf = atof(yytext); return T_number_float;}
\"([^"])*\" {strcpy(yylval.str,yytext); return T_string;}


{newline}  	{/* do nothing. The var yylineno holds the line number */ }
[ \t] 		{ /* nothing to be done when space and a tab are found!*/ }
. 			{    /* A simple error message! */
			 printf("Lexical Analysis: Unexpected String! :: %s  in line %d.\n",yytext,yylineno); }

%%
/* Comment (1). The lexer returns the ASCII code of the character found!
Since the lexer reutrns tokens as integers in the case of a single character we do not
need to specify a new token as in the case of keywords above. We simply return the ASCII code itself.
*/
