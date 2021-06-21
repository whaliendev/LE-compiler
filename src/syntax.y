%{
    #include <stdio.h>
    #include "node.h"
    #include "lex.yy.c"
    #define YYERROR_VERBOSE 1
    pNode root;
%}

// type
%union{
    pNode node;
}

// terminal tokens
%token <node> INT FLOAT

%token <node> RELOP

%token <node> PLUS MINUS STAR DIV

%token <node> AND OR NOT

%token <node> LP RP

%token <node> NEWLINE

// non-terminal tokens
%type <node> Input
%type <node> Line
%type <node> Exp

%%

Input: /* empty string */
    |   Input NEWLINE
    |   error NEWLINE
    ;

Line:   NEWLINE
    |   Exp NEWLINE
    |   error NEWLINE
    ;

Exp:    Exp PLUS Exp
    |   Exp MINUS Exp
    |   Exp STAR Exp
    |   Exp DIV Exp
    |   Exp AND Exp
    |   Exp OR Exp
    |   Exp RELOP Exp
    |   MINUS Exp
    |   NOT Exp
    |   LP Exp RP
    |   INT
    |   FLOAT
    |   error RP
    ;

%%


void yyerror(char const* msg){
    fprintf(stderr, "Syntax error at line %d: %s.\n", yylineno, msg);
}