%{
	#include <stdio.h>
	#include "mytool.tab.h"
%}
digit	[0-9]
%%
{digit}+ {
yylval = *yytext;
return VALUE; 
}
[<] 	{
yylval = *yytext;
return LT;
}
%%
int yywrap(void)
{
	return 1;
}
