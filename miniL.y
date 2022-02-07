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
	   BEGIN_PARAMS declarations END_PARAMS
 	   BEGIN_LOCALS declarations END_LOCALS
	   BEGIN_BODY statements END_BODY
	   {printf("function -> FUNCTION IDENT SEMICOLON\n");} 
	   {printf("	     BEGIN_PARAMS declarations END_PARAMS\n");} 
	   {printf("  	     BEGIN_LOCALS declarations END_LOCALS\n");}
	   {printf("	     BEGIN_BODY statements END_BODY\n");}
	   ;

declarations: /*epsilon*/
	    {printf("declarations->epsilon\n");}
		|declaration SEMICOLON declarations
		{printf("declarations->declaration SEMICOLON declarations\n");}
		|declaration error {yyerror;}
		;

declaration:	IDENT COLON INTEGER
	   	{printf("declaration->IDENT COLON INTEGER\n");}
		|IDENT COLON ARRAY L_SQUARE_BRACKET NUM R_SQUARE_BRACKET OF INTEGER
		{printf("declaration->IDENT COLON ARRAY L_SQUARE_BRACKET NUM %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
		;

	
statements:	statement SEMICOLON statements
	  	{printf("statements->statement SEMICOLON statements\n");}
		|statement SEMICOLON
		{printf("statements->statement SEMICOLON\n");}
		| statement error {yyerror;}
		;

statement:	vars
	  	{printf("statement->vars\n");}
	  	|ifs
		{printf("statement->ifs\n");}
		|whiles
		{printf("statement->whiles\n");}
		|dos
		{printf("statement->dos\n");}
		|reads
		{printf("statement->reads\n");}
		|writes
		{printf("statement->writes\n");}
		|continues
		{printf("statement->continues\n");}
		|breaks
		{printf("statement->breaks\n");}
		|returns
		{printf("statement->returns\n");}
		;

vars:	var ASSIGN expression
    	{printf("vars->var ASSIGN expression\n");}
		;

ifs:	IF bool_exp THEN statements ENDIF
   		{printf("ifs->IF bool_exp THEN statements ENDIF\n");}
		|IF bool_exp THEN statements ELSE statements ENDIF
		{printf("ifs->IF bool_exp THEN statements ELSE statements ENDIF\n");}
		;

whiles:	WHILE bool_exp BEGINLOOP statements ENDLOOP
      	{printf("whiles->WHILE bool_exp BEGINLOOP statements ENDLOOP\n");}
		;

dos:	DO BEGINLOOP statements ENDLOOP WHILE bool_exp
   		{printf("dos-> DO BEGINLOOP statements ENDLOOP WHILE bool_exp\n");}
		;

varLoop:
       	{printf("varLoop->epsilon\n");}
		|COMMA var varLoop
		{printf("varLoop-> COMMA var varLoop\n");}
		;

reads:  READ var varLoop
     	{printf("reads->READ var varLoop\n");}
		;
     
writes: WRITE var varLoop
      	{printf("writes->WRITE var varLoop\n");}
		;

continues:  CONTINUE
	 	{printf("continues->CONTINUE\n");}
		;
breaks : BREAK
		{printf("breaks -> BREAK \n");}


returns:    RETURN expression
       	{printf("returns->RETURN expression\n");}
		;

bool_exp : bool_exp expression comp expression
	   {printf("bool_exp -> bool_exp expression comp expression\n");}
	   |NOT bool_exp
	   {printf("bool_exp -> NOT bool_exp\n");}
	   |/*epsilon*/
	   {printf("bool_exp -> epsilon\n");}
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
		| expression ADD mul_exp {printf("expression -> expression ADD mul_exp\n");}
		| expression SUB mul_exp {printf("expression -> expression SUB mul_exp\n");}
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
	|IDENT L_PAREN R_PAREN
	 {printf("term -> IDENT L_PAREN R_PAREN\n");}
	|IDENT L_PAREN expression_list R_PAREN
         {printf("mul_exp -> IDENT L_PAREN expression R_PAREN\n");}
	;

expression_list : expression_list COMMA expression
                {printf("expression_list -> expression_list COMMA expression\n");}
		| expression
		{printf("expression_list -> expression\n");}
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
