%{
#include <stdio.h>
void yyerror(const char * c);
int yylex();
extern int yylineno;
extern char *yytext;

%}

%union 
{       char character;
        double decimal;
        int number;
        char *string;
}
%token <character> CHAR
%token <decimal> DOUBLE;
%token <number> INTEGER;
%token <string> STRING VAR_NAME;
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

declaration : VAR_NAME ASSIGN INTEGER                 { printf("int %s = %d", $1, $3); }
            | VAR_NAME ASSIGN STRING                  { printf("char * %s = %s", $1, $3); }
            | VAR_NAME ASSIGN DOUBLE                  { printf("double %s = %lf", $1, $3); }
            | VAR_NAME ASSIGN CHAR                    { printf("char %s = %d", $1, $3); }
            | VAR_NAME COLON T_NUMBER ASSIGN INTEGER  { printf("int %s = %d", $1, $5); }
            | VAR_NAME COLON T_STRING ASSIGN STRING   { printf("char * %s = %s", $1, $5); }
            | VAR_NAME COLON T_DECIMAL ASSIGN DOUBLE  { printf("double %s = %lf", $1, $5); }
            | VAR_NAME COLON T_CHAR ASSIGN CHAR       { printf("char %s = %d", $1, $5); }  /*guardamos los caracteres como si fuesen numeros*/
            ;

definition : VAR_NAME COLON T_NUMBER    { printf("int %s", $1); }
           | VAR_NAME COLON T_STRING    { printf("char * %s", $1); }
           | VAR_NAME COLON T_DECIMAL   { printf("double %s", $1); }
           | VAR_NAME COLON T_CHAR      { printf("char %s", $1); }
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
    printf("%s", $1);
};

assign: ASSIGN {
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

int main (){
	yyparse();
}

void yyerror(const char * c)
{
	fflush(stdout);
	fprintf(stderr, "Error: %s at line %d\n", c, yylineno);
	fprintf(stderr, "Pata sucia does not expect '%s'\n", yytext);
}
