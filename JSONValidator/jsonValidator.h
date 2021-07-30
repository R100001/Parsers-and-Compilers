/* Definition of the supported types. This is an enumerated type.*/
#ifndef __jsonValidatorSymbolTable__
#define __jsonValidatorSymbolTable__
/* Type Definitions (enum)  */
typedef enum {type_error, type_integer, type_real, type_string, type_object, type_array, type_constant} jsonType;

/* Macros */
#define ENTITY_ALREADY_DEFINED(ENTITY) {printf("Entity: %s\n", ENTITY);\
										yyerror("Entity already defined");}
#define ENTITY_NOT_DEFINED(ENTITY) {printf("Entity: %s\n", ENTITY);\
									yyerror("Entity has not been declared");}
#define TYPE_MISSMATCH(FIRSTENTITY, FIRSTENTITYTYPE, SECONDENTITYTYPE)\
		{printf("Entity (%s : %s) Expected Type %s \n", FIRSTENTITY, SECONDENTITYTYPE, FIRSTENTITYTYPE);\
		 yyerror("Type Missmatch!");}
#define LENGTH_MISSMATCH(FIRSTENTITY, SECONDENTITY, FIRSTENTITYLENGTH, SECONDENTITYLENGTH)\
		{printf("Entity (%s : %s) Expected Length %d, not %d \n", FIRSTENTITY, SECONDENTITY,\
				FIRSTENTITYLENGTH, SECONDENTITYLENGTH); yyerror("Length Missmatch!");}

/* Forward Function Declarations  */
void initSymbolTable();
int addvar(char *,jsonType,int);
int lookup(char *);
jsonType lookup_type(char *);
int lookup_length(char  *VariableName);
const char * nameOfType(int typeNumber);

#endif
