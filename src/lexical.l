%{
    #include <stdio.h>

    #include "node.h"
    #include "syntax.tab.h"

    extern unsigned lexError;
    int yycolumn = 1;

    #define YY_USER_ACTION \
        yylloc.first_line = yylloc.last_line = yylineno; \
        yylloc.first_column = yycolumn; \
        yylloc.last_column = yycolumn + yyleng-1; \
        yycolumn+=yyleng;

%}

%option yylineno

ws                  [ \t]
digit               [0-9]
letter              [_a-zA-Z]
RELOP               >|<|>=|<=|==|!=
PLUS                "+"
MINUS               "-"
STAR                "*"
DIV                 "/"
AND                 "&&"
OR                  "||"
NOT                 "!"
LP                  "("
RP                  ")"
INT                 0|[1-9]+[0-9]*
INT8                0[0-7]+
INT16               0[xX][0-9a-fA-F]+
WINT8               0({digit}|{letter})+
WINT16              0[xX]({digit}|{letter})+
WINT                {digit}*|{digit}+({digit}|[a-zA-Z])+
FLOAT               {digit}+"."{digit}+|{digit}*"."{digit}+[eE][+-]?{digit}+|{digit}+"."{digit}*[eE][+-]?{digit}+

%%
"/*"[^\*]*[\*]+([^\*/][^\*]*[\*]+)*"/"  { 
    if(!lexError) {
        printf("\n");
        ECHO; 
        printf("\n"); 
    } 
}

"/*"                { 
    printf("\033[;31mError at line %d: lex error, unterminated comment \'%s\'\033[0m \n", yylineno, yytext); 
    lexError=1; 
}

"*/"                { 
    printf("\033[;31mError at line %d: syntax error, invalid syntax \'%s\'\033[0m\n", yylineno, yytext); 
}

"//".*              { 
    if(!lexError) {
        printf("\n");
        ECHO; 
        printf("\n"); 
    } 
}

{ws}+               { ; }
\n                  { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "NEWLINE", yytext); 
    yycolumn=1; 
    return NEWLINE; 
}

{RELOP}             { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "RELOP", yytext); 
    return RELOP; 
}

{PLUS}              { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "PLUS", yytext); 
    return PLUS; 
}

{MINUS}             { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "MINUS", yytext); 
    return MINUS; 
}

{STAR}              { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "STAR", yytext); 
    return STAR; 
}

{DIV}               { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "DIV",  yytext); 
    return DIV; 
}

{AND}               { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER,  "AND", yytext); 
    return AND; 
}

{OR}                { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "OR", yytext); 
    return OR; 
}

{NOT}               { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "NOT", yytext); 
    return NOT; 
}

{LP}                { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "LP", yytext); 
    return LP; 
}
{RP}                { 
    yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "RP", yytext); 
    return RP; 
}

{INT}               { 
    yylval.node=newTokenNode(yylineno, TOKEN_INT, "INT", yytext); 
    return INT; 
}

{INT8}              { 
    yylval.node=newTokenNode(yylineno, TOKEN_INT, "INT", NULL);
    sscanf(yytext, "0%o", &(yylval.node->intVal));
    return INT;
}
{INT16}             {
    yylval.node=newTokenNode(yylineno, TOKEN_INT, "INT", NULL);
    if(yytext[1]=='x')
        sscanf(yytext, "0x%x", &(yylval.node->intVal));
    else 
        sscanf(yytext, "0X%x", &(yylval.node->intVal));
    return INT;
}
{FLOAT}             { yylval.node=newTokenNode(yylineno, TOKEN_FLOAT, "FLOAT", yytext); return FLOAT; }

{WINT16}                        { printf("\033[;31mError at Line %d: lex error, illegal hex int number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{WINT8}                         { printf("\033[;31mError at Line %d: lex error, illegal octal int number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{WINT}                          { printf("\033[;31mError at Line %d: lex error, illegal int number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
"."{digit}+                     { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{digit}+"."                     { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{digit}*"."{digit}+[eE]         { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{digit}+"."{digit}*[eE]         { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{digit}+[eE][+-]?{digit}*       { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
"."[eE][+-]?{digit}+            { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{letter}+                       { printf("\033[;31mError at Line %d: lex error, mysterious characters \'%s\'\033[0m\n", yylineno, yytext); lexError=1; }
.                               { printf("\033[;31mError at Line %d: lex error, mysterious character \'%s\'\033[0m\n", yylineno, yytext); lexError=1; }

%%