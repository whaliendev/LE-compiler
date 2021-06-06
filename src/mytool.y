%{
	#include <stdio.h>
	int yylex(void);  
	void yyerror(char const *);      
%}
%token VALUE
%token LT
%left LT
%%
S: R {{if($1)printf("Output: true.");else printf("Output: false."); return 0;}}
;
R: VALUE LT VALUE {$$ = ($1 < $3);}
;
%%
int main()
{
	yyparse();
	return 0;
}
void yyerror(char const *msg)  
{  
    fprintf(stderr, "%s\n",msg);  
}
