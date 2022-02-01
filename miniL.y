    /* cs152-miniL phase2 */
%{
void yyerror(const char *msg);
extern int currentLine;
extern int currentPosition;

#include <stdio.h>
#include <stdlib.h>

%}

%union{
  /* put your types here */
  char* identVal;
  int numVal;
}

%error-verbose
%locations

/* reserved words */
%token FUNCTION
%token BEGIN_PARAMS
%token END_PARAMS
%token BEGIN_LOCALS
%token END_LOCALS
%token BEGIN_BODY
%token END_BODY
%token INTEGER
%token ARRAY
%token OF
%token IF
%token THEN
%token ENDIF
%token ELSE
%token WHILE
%token DO
%token BEGINLOOP
%token ENDLOOP
%token CONTINUE
%token BREAK
%token READ
%token WRITE
%token NOT
%token TRUE
%token FALSE
%token RETURN

/* arithmetic operators */
%token SUB
%token ADD
%token MULT
%token DIV
%token MOD

/* comparison operators */
%token EQ
%token NEQ
%token LT
%token GT
%token LTE
%token GTE

/* identifiers and numbers */
%token <numVal> NUM
%token <identVal> IDENT

/* other special symbols */
%token SEMICOLON
%token COLON
%token COMMA
%token L_PAREN
%token R_PAREN
%token L_SQUARE_BRACKET
%token R_SQUARE_BRACKET
%token ASSIGN


/* %start program */
%start start



    /* write your rules here */

%%

start : /*epsilon*/{printf("start -> epsilon\n");}|
	start function 
	{printf("start -> start function");}
	;


function : FUNCTION IDENT SEMICOLON 
	   BEGIN_PARAMS declaration END_PARAMS
 	   BEGIN_LOCALS declaration END_LOCALS
	   BEGIN_BODY statement SEMICOLON END_BODY
	   {printf("function -> FUNCTION IDENT SEMICOLON\n");} 
	   {printf("	     BEGIN_PARAMS declaration END_PARAMS\n");} 
	   {printf("  	     BEGIN_LOCALS declaration END_LOCALS\n");}
	   {printf("	     BEGIN_BODY statement SEMICOLON END_BODY\n");}
	   ;

declaration : /*epsilon*/
		{printf("declaration -> epsilon\n");}
	     |IDENT COLON INTEGER SEMICOLON
		{printf("delcartion -> IDENT COLON INTEGER SEMICOLON\n");}
	     |IDENT COLON
	      ARRAY L_SQUARE_BRACKET NUM R_SQUARE_BRACKET OF
	      INTEGER SEMICOLON
	      {printf("declaration -> IDENT COLON ARRAY[NUM] OF INTEGER SEMICOLON\n");}
	      ;

statement : 	var ASSIGN expression
		{printf("statement -> var ASSIGN expression\n");}
		| IF bool_exp THEN statement ENDIF
		{printf("statement -> IF bool_exp THEN statement SEMICOLON ENDIF\n");}
		| IF bool_exp THEN statement ELSE statement ENDIF
		{printf("statement -> IF bool_exp THEN statement ELSE statement SEMI\n");}
		| WHILE bool_exp BEGINLOOP statement SEMICOLON ENDLOOP
		{printf("statement -> \n");}
		| DO BEGINLOOP statement SEMICOLON ENDLOOP WHILE bool_exp
		{printf("statement -> DO BEGINLOOP statement SEMICOLON ENDLOOP WHILE bool_exp\n");}
		| READ var
		{printf("statement -> READ var\n");}
		| WRITE var
		{printf("statement -> WRITE var\n");}
		| CONTINUE
		{printf("statement -> CONTINUE\n");}
		| BREAK
		{printf("statement -> BREAK\n");}
		| RETURN expression
		{printf("statement -> RETURN expression\n");}
		| 
		{printf("statement -> statement SEMICOLON\n");}
		;

bool_exp : expression comp expression
	   {printf("bool_exp -> bool_exp expression comp expression\n");}
	   |NOT 
	   {printf("NOT DONE\n");}
	   |/*epsilon*/
	   {printf("NOT DONE\n");}
	   ;

comp :   EQ
	{printf("comp -> EQ\n");}
	|NEQ
        {printf("comp -> NEQ\n");}
	|LT
        {printf("comp -> LT\n");}
	|GT
        {printf("comp -> GT\n");}
	|LTE
        {printf("comp -> LTE\n");}
	|GTE
        {printf("comp -> GTE\n");}
	;

expression : mul_exp {printf("expression -> mul_exp\n");}
		|expression ADD mul_exp {printf("expression -> expression ADD mul_exp\n");}
		|expression SUB mul_exp {printf("expression -> expression SUB mul_exp\n");}
		;

mul_exp : term
	 {printf("mul_exp -> term\n");}
       	 |mul_exp MULT term
         {printf("mul_exp -> mul_exp MULT term\n");}
	 |mul_exp DIV term
         {printf("mul_exp -> mul_exp DIV term\n");}
	 |mul_exp MOD term
         {printf("mul_exp -> mul_exp MOD term\n");}
	 ;

term : var
         {printf("term -> var\n");}
	|NUM
         {printf("term -> NUM\n");}
	|L_PAREN expression R_PAREN
         {printf("term -> L_PAREN expression R_PAREN\n");}
	|IDENT L_PAREN expression R_PAREN
         {printf("mul_exp -> IDENT L_PAREN expression R_PAREN\n");}
	;

var : IDENT
         {printf("var -> IDENT\n");}
	|IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET
         {printf("var -> IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n");}
	;


%%



int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
    printf("Error: On line %d, column %d: %s \n", currentLine, currentPosition, msg);
}
