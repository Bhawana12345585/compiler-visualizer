%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

char* create_node(char* label, char* left, char* right) {
    char* buf = (char*)malloc(8192);
    if (right) sprintf(buf, "(%s %s %s)", label, left, right);
    else sprintf(buf, "(%s %s)", label, left);
    return buf;
}
%}

%union { char* str; }
%token <str> ID NUM
%token INT FLOAT ASSIGN PLUS MINUS MUL DIV SEMI
%type <str> program stmt_list stmt expr

%left PLUS MINUS
%left MUL DIV

%%
program: stmt_list { 
    printf("{\"type\":\"tree\",\"value\":\"(Program %s)\"}\n", $1); 
};

stmt_list:
      stmt { $$ = $1; }
    | stmt_list stmt { 
        char* buf = (char*)malloc(16384);
        sprintf(buf, "%s %s", $1, $2);
        $$ = buf;
    }
    ;

stmt:
      INT ID SEMI {
          printf("{\"type\":\"symbol\",\"name\":\"%s\",\"dtype\":\"int\"}\n", $2);
          $$ = create_node("VarDecl", "int", $2);
      }
    | FLOAT ID SEMI {
          printf("{\"type\":\"symbol\",\"name\":\"%s\",\"dtype\":\"float\"}\n", $2);
          $$ = create_node("VarDecl", "float", $2);
      }
    | ID ASSIGN expr SEMI {
          printf("{\"type\":\"ic\",\"code\":\"%s = %s\"}\n", $1, $3);
          $$ = create_node("=", $1, $3);
      }
    ;

expr:
      ID { $$ = strdup($1); }
    | NUM { $$ = strdup($1); }
    | expr PLUS expr  { $$ = create_node("+", $1, $3); }
    | expr MINUS expr { $$ = create_node("-", $1, $3); }
    | expr MUL expr   { $$ = create_node("*", $1, $3); }
    | expr DIV expr   { $$ = create_node("/", $1, $3); }
    ;

%%
void yyerror(const char *s) { printf("{\"type\":\"error\",\"value\":\"Syntax Error\"}\n"); }
int main() { yyparse(); return 0; }