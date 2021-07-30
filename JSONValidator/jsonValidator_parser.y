/*
A simple syntax analyser for a mini language:

Syntax Analysis File
I. Sakellariou 2013 (based on simple examples from other authors)
*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "jsonValidator.h"

int yylex();
int yyerror (const char * msg);
/* This var holds the line number */ 
int yylineno;

%}

%union{
	char str[250];
	int num;
	float numf;
	struct {
    	jsonType type;
    	char name[250];
		int len;
	} entity;
}

/* Output informative error messages (bison Option) */
%define parse.error verbose

/* Token declarations */
%token <num>  T_number_int
%token <numf> T_number_float
%token <str> T_string

%token T_true
%token T_false
%token T_null

%token <entity> T_type

%type <entity> value
%type <entity> array
%type <entity> elements
%type <entity> object

%%

json: {initSymbolTable();} pair_declarations object
	;

pair_declarations: /* empty */
	| pair_decl pair_declarations
	;
	
pair_decl: '(' T_string  T_type ')' {if (!addvar($2, $3.type, -1)) ENTITY_ALREADY_DEFINED($2);}
	| '(' T_string T_type T_number_int ')' {if (!addvar($2, $3.type, $4)) ENTITY_ALREADY_DEFINED($2);}
	;


object: '{' '}'			{}
	| '{' members '}' 	{}
	;

members: pair
	| pair ',' members
	| error ',' members
	;

pair: T_string ':' value {
		if(!lookup($1)) {ENTITY_NOT_DEFINED($1);}
		else {
			jsonType firstType = lookup_type($1);
			if(firstType != $3.type){ 		/* Check types */
				if($3.type != type_string){
					TYPE_MISSMATCH($1, nameOfType(firstType), nameOfType($3.type));
				}
				else{
					char* tempStr = strdup($3.name);
					TYPE_MISSMATCH($1, nameOfType(firstType), tempStr);
					free(tempStr);
				}
			}
			if(firstType == type_array) {	/* Check array sizes */
				int firstLength = lookup_length($1);
				if( firstLength != $3.len)
					LENGTH_MISSMATCH($1,  nameOfType($3.type), firstLength, $3.len);
			}
		}}
	;

array:  '[' ']' 		{$$.len = 0;}
	| '[' elements ']' 	{$$.len = $2.len;}
	;

elements: value				{$$.len = 1;}
	| value ',' elements	{$$.len = 1 + $3.len;}
	;

value: 	T_string		{$$.type = type_string; strcpy($$.name, $1);}
	| T_number_int 		{$$.type = type_integer;}
	| T_number_float 	{$$.type = type_real;}
	| object 			{$$.type = type_object;}
	| array 			{$$.type = type_array; $$.len = $1.len;}
	| T_true 			{$$.type = type_constant;}
	| T_false 			{$$.type = type_constant;}
	| T_null 			{$$.type = type_constant;}
	;

%%
/* Line that includes the lexical analyser */
#include "jsonValidator.lex.c"

/* The usual yyerror, + line number indication. The variable line is defined in the lexical analyser.*/
int yyerror (const char * msg)
{
   fprintf(stderr, "ERROR in line %d: %s.\n", yylineno,msg);
}

/*
NOT NEEDED ANY MORE extern FILE *yyin, *yyout;

*/

/* Main */
int main (int argc, char ** argv)
{ ++argv, --argc; /* skip over program name */
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;

  int res = yyparse();
  printf("Total Syntax Errors found %d \n",yynerrs);

}
