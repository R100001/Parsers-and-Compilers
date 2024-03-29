%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sglib.h"
/* Just for being able to show the line number were the error occurs.*/
extern FILE *yyout;
extern int yylineno;
int the_errors = 0;
extern int yylex();
int yyerror(const char *);

/* The file that contains all the functions */
#include "jvmSimp.h"

#define TYPEDESCRIPTOR(TYPE) ((TYPE == type_integer) ? "I" : "F")

%}
/* Output informative error messages (bison Option) */
%define parse.error verbose

/* Declaring the possible types of Symbols*/
%union{
   char *lexical;
   int intval;
   struct {
	    ParType type;
	    char * place;} se;
}

/* Token declarations and their respective types */

%token <lexical> T_num
%token <lexical> T_real
%token '('
%token ')'
%token <lexical> T_id

%token T_start "start"
%token T_end "end"
%token T_print "print"
%token T_type_integer "int"
%token T_type_float "real"
%token T_ceil "ceil"
%token T_floor "floor"

%token TK_PLUS_REAL "+."
%token TK_MINUS_REAL "-."
%token TK_TIMES_REAL "*."
%token TK_DIV_REAL   "/."

%type<se> expr


%%

program: "start" T_id {create_preample($2); symbolTable=NULL; }
			stmts "end"
			{fprintf(yyout,"return \n.end method\n\n");}
	;

/* A simple (very) definition of a list of statements.*/
stmts:  '(' stmt ')' {/* nothing */}
     |  '(' stmt ')' stmts 	{/* nothing */}
     |  '(' error ')' stmts
	;

stmt:  asmt	{/* nothing */}
	| printcmd {/* nothing */}
	;

printcmd: "print" expr  {
			   	fprintf(yyout,"getstatic java/lang/System/out Ljava/io/PrintStream;\n");
			    fprintf(yyout,"swap\n");
				fprintf(yyout,"invokevirtual java/io/PrintStream/println(%s)V\n", 
					TYPEDESCRIPTOR($2.type));}
	;

asmt: T_id expr
	{   
		if(!lookup($1)) addvar($1, $2.type);
		
		if(idType != $2.type){
			fix_type_to_integer($2.type);
			fix_type_to_real($2.type);
		}
		fprintf(yyout, "%sstore %d\n", typePrefix(lookup_type($1)), lookup_position($1));
    }
	;


expr:  T_num  {$$.type = type_integer; fprintf(yyout,"sipush %s\n",$1);}
	| T_real {$$.type = type_real; fprintf(yyout,"ldc %s\n",$1);}
	| T_id 	  {ParType idType = lookup_type($1);
			   fprintf(yyout, "%sload %d\n", typePrefix(idType),
											 lookup_position($1));
			  $$.type = idType;}
	| '(' expr ')' 	{$$.type = $2.type;}
	
	| '+' expr {fix_type_to_integer($2.type);} 
		  expr {fix_type_to_integer($4.type);
		  		fprintf(yyout, "iadd\n"); $$.type = type_integer;}
	| '-' expr {fix_type_to_integer($2.type);} 
		  expr {fix_type_to_integer($4.type);
		  		fprintf(yyout, "isub\n"); $$.type = type_integer;}
	| '*' expr {fix_type_to_integer($2.type);} 
		  expr {fix_type_to_integer($4.type);
		  		fprintf(yyout, "imul\n"); $$.type = type_integer;}
	| '/' expr {fix_type_to_integer($2.type);} 
		  expr {fix_type_to_integer($4.type);
		  		fprintf(yyout, "idiv\n"); $$.type = type_integer;}
	
	| "+." expr {fix_type_to_real($2.type);} 
		   expr {fix_type_to_real($4.type);
		  		 fprintf(yyout, "fadd\n"); $$.type = type_real;}
	| "-." expr {fix_type_to_real($2.type);} 
		   expr {fix_type_to_real($4.type);
		  		 fprintf(yyout, "fsub\n"); $$.type = type_real;}
	| "*." expr {fix_type_to_real($2.type);} 
		   expr {fix_type_to_real($4.type);
		  		 fprintf(yyout, "fmul\n"); $$.type = type_real;}
	| "/." expr {fix_type_to_real($2.type);} 
		   expr {fix_type_to_real($4.type);
		  		 fprintf(yyout, "fdiv\n"); $$.type = type_real;}

	| "ceil" expr  {if($2.type != type_integer){
						fprintf(yyout, "%s2d\n", typePrefix($2.type));
						fprintf(yyout, "invokestatic java/lang/Math/ceil(D)D\n");
						fprintf(yyout, "d2%s\n", typePrefix($2.type));}}
	| "floor" expr {if($2.type != type_integer){
						fprintf(yyout, "%s2d\n", typePrefix($2.type));
						fprintf(yyout, "invokestatic java/lang/Math/floor(D)D\n");
						fprintf(yyout, "d2%s\n", typePrefix($2.type));}}
  ;

%%

/* The usual yyerror */
int yyerror (const char * msg)
{
  fprintf(stderr, "ERROR: %s. on line %d.\n", msg,yylineno);
  the_errors++;
}

/* Other error Functions*/
/* The lexer... */
#include "jvmSimpLex.c"

/* Main */
int main(int argc, char **argv ){

   ++argv, --argc;  /* skip over program name */
   if ( argc > 0 )
       yyin = fopen( argv[0], "r" );
   else
       yyin = stdin;
   if ( argc > 1)
       yyout = fopen( argv[1], "w");
   else
	     yyout = stdout;

   int result = yyparse();
   printf("Errors found %d.\n",the_errors);
   fclose(yyout);
   if (the_errors != 0 && yyout != stdout) {
     remove(argv[1]);
      printf("No Code Generated.\n");}

  //print_symbol_table(); /* uncomment for debugging. */

  return result;
}
