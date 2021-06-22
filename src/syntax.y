%{
    #include <stdio.h>
    #include "node.h"
    #include "lex.yy.c"
    #include "enum.h"
    #define YYERROR_VERBOSE 1
    pNode root;
    int skipNum=0;
    extern int yyerror(char const *msg);
    unsigned lexError=0;
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
%type <node> Start

// precedence and associativity
%left AND OR
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LP RP


%%
Start:  Input                   { 
        $$ = newNode(@$.first_line, NOT_A_TOKEN, "Start", NULL, 1, $1); 
        root=$$; 
    }
    ;

Input: /* empty string */       { $$=newNode(@$.first_line,  NOT_A_TOKEN, "Input", NULL, 0); }
    |   Input Line              { 
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Input", NULL, 2, $1, $2); 
        if(!lexError&&$2!=NULL&&$2->child!=NULL&&$2->child->next!=NULL){
            $$->floatVal=$2->floatVal; 
            printf("Output: %s, %d\n", 
                $$->floatVal==0?"false":"true", skipNum); 
        }
        skipNum=0; 
    }
    ;

Line:   NEWLINE                 { $$=newNode(@$.first_line, NOT_A_TOKEN, "Line", NULL, 1, $1); }            
    |   Exp NEWLINE             { 
            $$=newNode(@$.first_line, NOT_A_TOKEN, "Line", NULL, 2, $1, $2); 
            if($1!=NULL){
                $$->floatVal=$1->floatVal; 
            }
        }
    |   error NEWLINE           { ; }
    ;

Exp:    Exp PLUS Exp            { 
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3); 
        $$->floatVal=$1->floatVal+$3->floatVal; 
    }
    |   Exp MINUS Exp           {
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);
        $$->floatVal=$1->floatVal-$3->floatVal;
    }
    |   Exp STAR Exp            {
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);
        $$->floatVal=$1->floatVal*$3->floatVal;
    }
    |   Exp DIV Exp             {
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1,  $2, $3);
        $$->floatVal=$1->floatVal/$3->floatVal;
    }
    |   Exp AND Exp             {
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);
        $$->floatVal=$1->floatVal&&$3->floatVal;
    }
    |   Exp OR Exp              {
        $$=newNode(@$.first_line,  NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);
        $$->floatVal=$1->floatVal||$3->floatVal;
    }
    |   Exp RELOP Exp           {
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);
        int len = $2->strLen;
        char *op=(char *)malloc(sizeof(char)*len);
        strncpy(op, $2->strVal, len);
        // printf("op: %s\n", op);
        // printf("1: %f, 2: %f\n", $1->floatVal, $3->floatVal);
        if(strcmp(op, "==")==0){
            $$->floatVal=($1->floatVal-$3->floatVal<1e-6);
        }else if(strcmp(op, "!=")==0){
            $$->floatVal=!($1->floatVal-$3->floatVal<1e-6);
        }else if(strcmp(op, ">")==0){
            $$->floatVal=($1->floatVal>$3->floatVal);
        }else if(strcmp(op, "<")==0){
            $$->floatVal=($1->floatVal<$3->floatVal);
        }else if(strcmp(op, ">=")==0){
            $$->floatVal=($1->floatVal>=$3->floatVal);
        }else{
            $$->floatVal=($1->floatVal<=$3->floatVal);
        }
        // printf("floatVal: %f\n", $$->floatVal);
        free(op);
    }
    |   MINUS Exp               {
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 2, $1, $2);
        $$->floatVal=-$2->floatVal;
    }
    |   NOT Exp                 {
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 2, $1, $2);
        $$->floatVal=!$2->floatVal;
    }
    |   LP Exp RP               {
        $$=newNode(@$.first_line,  NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);
        $$->floatVal=$2->floatVal;
    }
    |   INT                     {
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 1, $1);
        $$->floatVal=$1->intVal;
    }
    |   FLOAT                   {
        $$=newNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 1, $1);
        $$->floatVal=$1->floatVal;
    }
    |   error RP                { ; }
    ;

%%


int yyerror(char const *msg){
    fprintf(stderr, "\033[;31mError at line %d: %s\033[0m\n", yylineno, msg);
    return 1;
}