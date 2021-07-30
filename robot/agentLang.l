
%{
#include <stdio.h>
#include <string.h>

/* Needed for syntax analyser*/
#define LEXEND			0 

#define T_NAME			300
#define T_OP			301
#define T_SENSOR		302
#define T_NUM			303
#define T_VAR			304
#define T_LEFT_CURLY	305
#define T_RIGHT_CURLY	306
#define T_INIT_NOINIT	307
#define T_ARROW			308
#define T_TRUE			309
#define T_MOVEFOR		310
#define T_TURN			311
#define T_STAY			312
#define T_DIRECTION		313

int line = 1;
%}

lower		[a-z]
caps		[A-Z]
nzdigits	[1-9]
digits		[0-9]

op			">"|"<"|"="
leftcurly	"{"
rightcurly	"}"
initandno	"init"|"no-init"
arrow		"=>"
true		"true"
movefor		"move forward"
turn		"turn"
stay		"stay"
direction	"left"|"right"
sensor		"left-laser"|"right-laser"|"front-sonar"

name		{lower}*
integer		{nzdigits}{digits}*
varname		{caps}({caps}|{lower})*

newline 	\n|\x0A|\x0D|\x0A

%%

{op}			{return T_OP;}
{leftcurly}		{return T_LEFT_CURLY;}
{rightcurly}	{return T_RIGHT_CURLY;}
{initandno}		{return T_INIT_NOINIT;}
{arrow}			{return T_ARROW;}
{true}			{return T_TRUE;}
{movefor}		{return T_MOVEFOR;}
{turn}			{return T_TURN;}
{stay}			{return T_STAY;}
{direction}		{return T_DIRECTION;}
{sensor}		{return T_SENSOR;}
{name}			{return T_NAME;}
{integer}		{return T_NUM;}
{varname}		{return T_VAR;}

. 			{/* Do Nothing */}
{newline}	{ line++; }
%%

int token = 0;

void agent(void);
void rules(void);
void rules_aux(void);
void rule(void);
void action(void);
void tok(void);
void direction(void);
void error_syntax(void);
void match(int tk);


void agent(){
	if (token == T_NAME){
		match(T_NAME);
		match(T_LEFT_CURLY);
		rules();
		match(T_RIGHT_CURLY);
	}
	else error_syntax();
}

void rules(){
	if (token == T_INIT_NOINIT){
		match(T_INIT_NOINIT);
		rules_aux();
	}
	else error_syntax();
}

void rules_aux(){
	if (token == T_SENSOR || token == T_TRUE){
		rule(); rules_aux();
	}
	else if (token != T_RIGHT_CURLY) error_syntax();
}

void rule(){
	if (token == T_SENSOR){
		match(T_SENSOR); 
		match(T_OP); 
		tok();
		match(T_ARROW);
		action();
	}
	else if (token == T_TRUE){
		match(T_TRUE);
		match(T_ARROW);
		action();
	}
	else error_syntax();
}

void action(){
	if (token == T_MOVEFOR){
		match(T_MOVEFOR); tok();
	}
	else if (token == T_TURN){ 
		match(T_TURN); direction(); tok();
	}
	else if (token == T_STAY) 
		match(T_STAY);
	else error_syntax();
}

void tok(){
	if (token == T_NUM) 
		match(T_NUM);
	else if (token == T_VAR) 
		match(T_VAR);
	else error_syntax();
}

void direction(){
	if (token == T_DIRECTION) match(T_DIRECTION);
	else error_syntax();
}

void error_syntax(void){
   	printf(" Syntax Error reading %s at line %d of input. \n",yytext, line);
   	exit(-1);
}

void match(int tk){

 	if (token == tk) token = yylex();
	else  error_syntax();
}




int main(int argc, char **argv ){
	++argv, --argc;  /* skip over program name */
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;

	token = yylex(); 
	agent();
	if (token == LEXEND) printf("\n Success! \n \n");
	else error_syntax();
	return 0;
}



