%{
    #include <stdio.h>
    #include "node.h"
    #include "lex.yy.c"
    #define YYERROR_VERBOSE 1
%}

%union{
    pNode node;
}