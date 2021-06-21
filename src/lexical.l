%{
    #include <stdio.h>

    #include "node.h"
    #include "syntax.tab.h"

    int yycolumn = 1;

    #define YY_USER_ACTION \
        yylloc.first_line = yyloc.last_line = yylineno; \
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
FLOAT               {digit}+"."{digit}+|{digit}*"."{digit}+[eE][+-]?{digit}+|{digit}+"."{digit}*[eE][+-]?{digit}+

%%
"/*"[^\*]*[\*]+([^\*/][^\*]*[\*]+)*"/"  { ECHO; }
"/*"                { printf("Lex error at line %d: unterminated comment \'%s\'. \n", yylineno, yytext); }
"*/"                { printf("Syntax error at line %d: you may want to nest comments in /* */ block", yylineno); }
"//".*              { ECHO; }

{ws}+               { ; }
\n|\r               { yycolumn = 1; }
\n                  { yylval.node=newTokenNOde(yylineno, TOKEN_OTHER, "NEWLINE", yytext); return NEWLINE; }
{RELOP}             { yylval.node=newTokenNode(yylineno, TOKEN_OTHER, "RELOP", yytext); return RELOP; }

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

{letter}+                       { printf("Lex error at Line %d: unsupported feature \"%s\".\n", yylineno, yytext); }
"."{digit}+                     { printf("Lex error at Line %d: Illegal floating point number \"%s\".\n", yylineno, yytext); }
{digit}+"."                     { printf("Lex error at Line %d: Illegal floating point number \"%s\".\n", yylineno, yytext); }
{digit}*"."{digit}+[eE]         { printf("Lex error at Line %d: Illegal floating point number \"%s\".\n", yylineno, yytext); }
{digit}+"."{digit}*[eE]         { printf("Lex error at Line %d: Illegal floating point number \"%s\".\n", yylineno, yytext); }
{digit}+[eE][+-]?{digit}*       { printf("Lex error at Line %d: Illegal floating point number \"%s\".\n", yylineno, yytext); }
"."[eE][+-]?{digit}+            { printf("Lex error at Line %d: Illegal floating point number \"%s\".\n", yylineno, yytext); }
.                               { printf("Lex error at Line %d: Mysterious character \'%s\'.\n", yylineno, yytext); }

%%