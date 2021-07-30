/*	File that implements a very simple symbol table.
    A naive implementation of a JSON symbol table for simple semantic checking.
    2017:Ilias Sakellariou
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sglib.h"
#include "jsonValidator.h"

/* External Error Function */
int yyerror(const char *);

/* 	Structure for storing JSON Entities in the symbol table
	  jsonEntity the name (string) of the entity
		jsonType is the type of values (see jsonValidator.h)
		length used in arrays (number of elements)
*/

typedef struct st_var {
	char *jsonEntity;
	jsonType type;
  	int length;
	struct st_var *next_st_var;
} ST_ENTRY;

/* Defining The Symbol Table */
typedef ST_ENTRY *ST_TABLE;
/* Definition required by the Lib (sglib) for the linked lists used in the symbol table.  */
#define ST_COMPARATOR(e1,e2) (strcmp(e1->jsonEntity,e2->jsonEntity))


/* Symbol Table Functions */

ST_TABLE symbolTable;

/* Initialising Symbol Table */
void initSymbolTable()
{
  symbolTable=NULL;
}

/* Function Definitions for Syntax and Semantic Analysis */

/* Adding a Variable entry to the symbol table.
   If the variable name exists in the symbol table, then it returns FALSE (0)
   else it returns TRUE (1). (needed for type checking)
*/
int addvar(char *VariableName,jsonType TypeDecl, int len)
{
	ST_ENTRY *newVar;

	if (!lookup(VariableName))
	{
		newVar = malloc(sizeof(ST_ENTRY));
		newVar->jsonEntity = strdup(VariableName);
		newVar->type = TypeDecl;
    	newVar->length = len;
		/* Calling the SGLIB function to add the entry*/
		SGLIB_LIST_ADD(ST_ENTRY, symbolTable, newVar, next_st_var);
		return 1;
	}
	else return 0; /* error */
}

/* Looking up a symbol in the symbol table. Returns 0 if symbol was not found. */

int lookup(char *VariableName) {

	ST_ENTRY *var, *result;
	var = malloc(sizeof(ST_ENTRY));
	var->jsonEntity = strdup(VariableName);
	SGLIB_LIST_FIND_MEMBER(ST_ENTRY,symbolTable,var,ST_COMPARATOR,next_st_var, result);
	free(var->jsonEntity);
	free(var);
   if (result == NULL) {return 0;}
   else {return 1;}
}

/* Looking up a symbol TYPE in the symbol table. Returns 0 if symbol was not found. */

jsonType lookup_type(char *VariableName)
{
	ST_ENTRY *var, *result;
	var = malloc(sizeof(ST_ENTRY));
	var->jsonEntity = strdup(VariableName);
	SGLIB_LIST_FIND_MEMBER(ST_ENTRY,symbolTable,var,ST_COMPARATOR,next_st_var, result);
  	free(var->jsonEntity);
	free(var);
   if (result == NULL) {return 0;}
   else {return result->type;}
}
/* Looking up a symbols LENGTH in the symbol table. Returns 0 if symbol was not found. */

int lookup_length(char  *VariableName)
{
	ST_ENTRY *var, *result;
	var = malloc(sizeof(ST_ENTRY));
	var->jsonEntity = strdup(VariableName);
	SGLIB_LIST_FIND_MEMBER(ST_ENTRY,symbolTable,var,ST_COMPARATOR,next_st_var, result);
	free(var->jsonEntity);
	free(var);
	if (result == NULL) {return 0;}
	else {return result->length;}
}


/* Printing the complete Symbol Table */
void print_symbol_table(void)
{
  ST_ENTRY *var;
  printf("\n Symbol Table Generated \n");
  SGLIB_LIST_MAP_ON_ELEMENTS(ST_ENTRY, symbolTable, var, next_st_var, {
    printf("ST:: Name %s Type %s Len %d\n", var->jsonEntity, nameOfType(var->type), var->length);
  });
}

/* "Returns the name of the type.*/
const char * nameOfType(int typeNumber){
   static char* nametypes[] = {"error", "integer", "real", "string", "object", "array", "contant" };
	 return nametypes[typeNumber];
}


/* end of function implemention */
