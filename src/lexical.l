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

    int relTot=0;
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
FLOAT               {digit}+"."{digit}+|{digit}*"."{digit}+[eE][+-]?{digit}+|{digit}+"."{digit}*[eE][+-]?{digit}+

%%
"/*"[^\*]*[\*]+([^\*/][^\*]*[\*]+)*"/"  { if(!lexError) {ECHO; printf("\n"); } }
"/*"                { printf("\033[;31mError at line %d: lex error, unterminated comment \'%s\'\033[0m \n", yylineno, yytext); lexError=1; }
"*/"                { printf("\033[;31mError at line %d: syntax error, invalid syntax \'%s\'\033[0m\n", yylineno, yytext); }
"//".*              { if(!lexError) {ECHO; printf("\n"); } }

{ws}+               { ; }
\n                  { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "NEWLINE", yytext); return NEWLINE; yycolumn=1; }
{RELOP}             { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "RELOP", yytext); relTot++; return RELOP; }

{PLUS}              { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "PLUS", yytext); return PLUS; }
{MINUS}             { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "MINUS", yytext); return MINUS; }
{STAR}              { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "STAR", yytext); return STAR; }
{DIV}               { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "DIV",  yytext); return DIV; }
{AND}               { yylval.node=newTokenNode(yylineno, TOKEN_OTHER,  "AND", yytext); return AND; }
{OR}                { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "OR", yytext); return OR; }
{NOT}               { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "NOT", yytext); return NOT; }

{LP}                { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "LP", yytext); return LP; }
{RP}                { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "RP", yytext); return RP; }

{INT}               { yylval.node=newTokenNode(yylineno, TOKEN_INT, "INT", yytext); return INT; }
{FLOAT}             { yylval.node=newTokenNode(yylineno, TOKEN_FLOAT, "FLOAT", yytext); return FLOAT; }

"."{digit}+                     { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{digit}+"."                     { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{digit}*"."{digit}+[eE]         { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{digit}+"."{digit}*[eE]         { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
{digit}+[eE][+-]?{digit}*       { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
"."[eE][+-]?{digit}+            { printf("\033[;31mError at Line %d: lex error, illegal floating point number \"%s\"\033[0m\n", yylineno, yytext); lexError=1; }
.                               { printf("\033[;31mError at Line %d: lex error, mysterious character \'%s\'\033[0m\n", yylineno, yytext); lexError=1; }

%%