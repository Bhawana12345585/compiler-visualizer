%{
#include "parser.tab.h"
#include <stdio.h>
#include <string.h>
%}

%%
"int"       { printf("{\"type\":\"token\",\"value\":\"int\"}\n"); return INT; }
"float"     { printf("{\"type\":\"token\",\"value\":\"float\"}\n"); return FLOAT; }

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("{\"type\":\"token\",\"value\":\"%s\"}\n", yytext);
    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+ {
    printf("{\"type\":\"token\",\"value\":\"%s\"}\n", yytext);
    yylval.str = strdup(yytext);
    return NUM;
}

"="     { printf("{\"type\":\"token\",\"value\":\"=\"}\n"); return ASSIGN; }
"+"     { printf("{\"type\":\"token\",\"value\":\"+\"}\n"); return PLUS; }
"-"     { printf("{\"type\":\"token\",\"value\":\"-\"}\n"); return MINUS; }
"*"     { printf("{\"type\":\"token\",\"value\":\"*\"}\n"); return MUL; }
"/"     { printf("{\"type\":\"token\",\"value\":\"/\"}\n"); return DIV; }
";"     { printf("{\"type\":\"token\",\"value\":\";\"}\n"); return SEMI; }

[ \t\n\r] ;
.       { printf("{\"type\":\"error\",\"value\":\"Unexpected: %s\"}\n", yytext); }

%%
int yywrap() { return 1; }