%{

#include <stdlib.h>
#include <string.h>

int line = 1;

%}

lower		[a-z]
caps		[A-Z]
nzdigits	[1-9]
digits		[0-9]
integer		{nzdigits}{digits}*

name		{lower}+
var			\?({lower}|{caps})+
num			{integer}

newline 	\n|\x0A|\x0D|\x0A


%%

"to"		{ return T_TO; }
"to-report"	{ return T_TOREPORT; }
"end"		{ return T_END; }
"if"		{ return T_IF; }
"report"	{ return T_REPORT; }

"("			{ return '('; }
")"			{ return ')'; }
"["			{ return '['; }
"]"			{ return ']'; }

"="			{ return '='; }

{name}		{ return T_NAME; }
{var}		{ return T_VAR;	}
{num}		{ return T_NUM;	}

[ \t]		{ /* Do nothing */ }
. 			{ /* Do Nothing */ }
{newline} 	{ ++yylineno; }

%%


