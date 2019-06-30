%{
#include <stdio.h>
#include <string.h>
#include "hashmap.h"

static char * _CHAR_ = "char";
static char * _INTEGER_ = "integer";
static char * _DOUBLE_ = "double";
static char * _STRING_ = "string";

void add_var(char * varname, char * type);
void check_types(char * varname);
void yyerror(const char * c);
int yylex();
extern int yylineno;
extern char *yytext;
static map_t map;
static char * current_varname;
static char * current_type;
static int assign_flag;
%}

%union 
{       char character;
        double decimal;
        int number;
        char *string;
}
%token <character> CHAR
%token <decimal> DOUBLE
%token <number> INTEGER
%token <string> STRING VAR_NAME
%token VAR LIT IF ELSE DO WHILE OPEN_PARENTHESIS CLOSE_PARENTHESIS OPEN_BLOCK CLOSE_BLOCK ASSIGN ADD SUB DIV MUL MOD ADD_ADD SUB_SUB OR AND NEG LT GT LE GE EQ DIST PRINT START END DELIMITER COMA COLON T_NUMBER T_DECIMAL T_STRING T_CHAR TRUE FALSE GET_N GET_C GET_D STOP

%left LT GT LE GE EQ DIST
%left AND OR
%left ADD SUB
%left DIV MUL MOD
%left NEG

%start comienza

%%

comienza : start statements end;

statements : statement statements | /*lambda*/ {};

statement : variables delimiter
          | var_name assign exp delimiter
          | var_name assign string delimiter
          | var_name math_shortcut delimiter
          | print delimiter
          | get delimiter
          | flow_control
          ;

print : do_print open_parenthesis string format close_parenthesis
      | do_print open_parenthesis string close_parenthesis
      ;

format : coma string format
       | coma var_name format
       | coma integer format
       | coma double format
       | coma string
       | coma var_name
       | coma integer
       | coma double
       ;

get : GET_C OPEN_PARENTHESIS VAR_NAME CLOSE_PARENTHESIS { printf("%s = getchar()", $3); }
    | GET_N OPEN_PARENTHESIS VAR_NAME CLOSE_PARENTHESIS { printf("scanf(\"%%d\", &%s)", $3); }
    | GET_D OPEN_PARENTHESIS VAR_NAME CLOSE_PARENTHESIS { printf("scanf(\"%%lf\", &%s)", $3); }
    ;

variables : variable declaration
          | variable definition
          | literal  declaration
          ;

declaration : VAR_NAME ASSIGN INTEGER                 { add_var($1, _INTEGER_);printf("int %s = %d", $1, $3); }
            | VAR_NAME ASSIGN STRING                  { add_var($1, _STRING_);printf("char * %s = %s", $1, $3); }
            | VAR_NAME ASSIGN DOUBLE                  { add_var($1, _DOUBLE_);printf("double %s = %lf", $1, $3); }
            | VAR_NAME ASSIGN CHAR                    { add_var($1, _CHAR_);printf("char %s = %d", $1, $3); }
            | VAR_NAME COLON T_NUMBER ASSIGN INTEGER  { add_var($1, _INTEGER_);printf("int %s = %d", $1, $5); }
            | VAR_NAME COLON T_STRING ASSIGN STRING   { add_var($1, _STRING_);printf("char * %s = %s", $1, $5); }
            | VAR_NAME COLON T_DECIMAL ASSIGN DOUBLE  { add_var($1, _DOUBLE_);printf("double %s = %lf", $1, $5); }
            | VAR_NAME COLON T_CHAR ASSIGN CHAR       { add_var($1, _CHAR_);printf("char %s = %d", $1, $5); }  /*guardamos los caracteres como si fuesen numeros*/
            ;

definition : VAR_NAME COLON T_NUMBER    { add_var($1, _INTEGER_);printf("int %s", $1); }
           | VAR_NAME COLON T_STRING    { add_var($1, _STRING_);printf("char * %s", $1); }
           | VAR_NAME COLON T_DECIMAL   { add_var($1, _DOUBLE_);printf("double %s", $1); }
           | VAR_NAME COLON T_CHAR      { add_var($1, _CHAR_);printf("char %s", $1); }
           ;

flow_control : if open_parenthesis boolean_exp close_parenthesis open_block statements close_block
	     | if open_parenthesis boolean_exp close_parenthesis open_block statements close_block else open_block statements close_block;
	     | do open_block statements close_block while open_parenthesis boolean_exp close_parenthesis delimiter
	     | while open_parenthesis boolean_exp close_parenthesis open_block statements close_block
             | stop delimiter
	     ;

boolean_exp : true
            | false
            | cmp
            | boolean_exp or boolean_exp
            | boolean_exp and boolean_exp
            | neg boolean_exp
            | open_parenthesis boolean_exp close_parenthesis
            ;

cmp :   exp lt exp
    |	exp gt exp
    |	exp eq exp
    |	exp dist exp
    |	exp le exp
    |	exp ge exp
    ;

exp : open_parenthesis exp close_parenthesis
    | exp add exp
    | exp sub exp
    | exp mod exp
    | exp div exp
    | exp mul exp
    | var_name
    | integer
    | character
    | double
    ;
    
math_shortcut : add_add
              | sub_sub
              ;

start: START {
	printf("#include <stdio.h>\n int main(int argc, char *argv[]) { ");
};

end: END{
	printf(" } ");
};

do_print: PRINT {
    	printf("printf");
};

if : IF {
    	printf("if");
};

else : ELSE {
    	printf("else");
};

do : DO {
    	printf("do");
};

while : WHILE {
    	printf("while");
};

string: STRING {
	if (assign_flag && current_type != NULL) {
		if (strcmp(_STRING_, current_type) != 0) {
               		yyerror("uncompatible types");
               	}
	}
    	printf("%s",$1);
};

integer: INTEGER {
    	printf("%d",$1);
};

character: CHAR {
    	printf("%d",$1);
};

double: DOUBLE {
    	printf("%lf",$1);
};

variable : VAR {
    /*no hacemos nada*/
};

literal : LIT {
    	printf("const ");
};

true: TRUE{
    	printf(" 1 ");
};

false: FALSE{
    	printf(" 0 ");
};

var_name : VAR_NAME {
	char * aux;
    	if (hashmap_get(map, $1, (void**)&aux) == MAP_OK) {
    		if (current_varname == NULL) {
    			current_varname = $1;
			current_type = aux;
		}
		if (assign_flag) {
			check_types($1);
                }
    	} else {
    		yyerror("inexsistant variable");
        }
    	printf("%s", $1);
};

assign: ASSIGN {
	assign_flag = 1;
	printf(" = ");
};

add_add : ADD_ADD {
    	printf("++");
};

sub_sub : SUB_SUB {
    	printf("--");
};

or: OR {
	printf(" || ");
};

and: AND {
	printf(" && ");
};

mul: MUL {
	printf(" * ");
};

div: DIV {
   	printf(" / ");
};

add: ADD {
	printf(" + ");
};

sub: SUB {
	printf(" - ");
};

neg: NEG {
	printf(" ! ");
};

lt: LT {
	printf(" < ");
};

gt: GT {
	printf(" > ");
};

eq: EQ {
	printf(" == ");
};

dist: DIST {
	printf(" != ");
};

le: LE {
	printf(" <= ");
};

ge: GE {
	printf(" >= ");
};

mod: MOD {
	printf(" %% ");	 
};

delimiter: DELIMITER {
	current_varname = NULL;
	current_type = NULL;
	assign_flag = 0;
	printf(";");
};

open_parenthesis: OPEN_PARENTHESIS {
	printf("(");
};

close_parenthesis: CLOSE_PARENTHESIS {
	printf(")");
};

open_block : OPEN_BLOCK {
	printf("{");
};

close_block : CLOSE_BLOCK {
	printf("}");
};

coma : COMA {
	printf(",");     
};

stop : STOP {
    	printf("break");
};

%%

void add_var(char * varname, char * type) {
	char * aux;
	if (hashmap_get(map, varname, (void**)&aux) == MAP_OK) {
    		yyerror("redefinition of variable");
  	} else {
	  	hashmap_put(map, varname, type);
  	}
}

void check_types(char * varname) {
	char * aux;
	if (hashmap_get(map, varname, (void**)&aux) == MAP_OK) {
		if (strcmp(aux, current_type) != 0) {
			yyerror("uncompatible types");
		}
	} else {
		yyerror("inexsistant variable");
	}
}

int main (){
   	map = hashmap_new();
   	current_varname = NULL;
        current_type = NULL;
        assign_flag = 0;
	yyparse();
	hashmap_free(map);
}

void yyerror(const char * c)
{
	fflush(stdout);
	fprintf(stderr, "Error: %s at line %d\n", c, yylineno);
	fprintf(stderr, "FerLang sucia does not expect '%s'\n", yytext);
}
