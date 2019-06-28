%{
#include "y.tab.h"
#include <strings.h>
#include <stdlib.h>
extern int yyval, yylineno;
%}

STRING ["][^\n\r]*["]
CHAR ['][\x20-\x7E][']
INTEGER [-]?[0-9]+
DOUBLE	[-]?[0-9]+\.[0-9]+
VAR_NAME [a-zA-Z][a-zA-Z0-9_]*


%%
[\n] 			        { yylineno = yylineno + 1; }
[ \t]          			{                          }
"#".*""                 { /* Comentario, puede ser cualquier cosa y lo ignoramos */ }
{INTEGER}				{
							yylval.number = atoi(yytext);
							return INTEGER;
						}
{CHAR}                  {
                            yylval.character = yytext[1];
                            return CHAR;
}
{DOUBLE}				{
                            yylval.decimal = atof(yytext);
                            return DOUBLE;
}
{STRING}				{
							yylval.string = strdup(yytext);
							return STRING;
						}
","                     {return COMA;}
":"                     {return COLON;}
"number"                {return T_NUMBER;}
"character"             {return T_CHAR;}
"string"                {return T_STRING;}
"decimal"               {return T_DECIMAL;}
"true"					{return TRUE;}
"false"					{return FALSE;}
"if"					{return IF;}
"else"					{return ELSE;}
"do"					{return DO;}
"while"					{return WHILE;}
"stop"					{return STOP;}
"var"					{return VAR;}
"let"					{return LIT;}
"("						{return OPEN_PARENTHESIS;}
")"						{return CLOSE_PARENTHESIS;}
"{" 					{return OPEN_BLOCK;}
"}" 					{return CLOSE_BLOCK;}
"="						{return ASSIGN;}
"+"						{return ADD;}
"-"						{return SUB;}
"*"						{return MUL;}
"/"						{return DIV;}
"%"                     {return MOD;}
"++"					{return ADD_ADD;}
"--"					{return SUB_SUB;}
"or"					{return OR;}
"and"					{return AND;}
"not"					{return NEG;}
"<"						{return LT;}
">"						{return GT;}
"<="					{return LE;}
">="					{return GE;}
"=="					{return EQ;}
"!="					{return DIST;}
"put"					{return PRINT;}
"getnum"				{return GET_N;}
"getchar"				{return GET_C;}
"getdec"				{return GET_D;}
"start"					{return START;}
"end"					{return END;}
";"						{return DELIMITER;}
{VAR_NAME}				{
							yylval.string = strdup(yytext);
							return VAR_NAME;
						}
.						{fprintf(stderr, "Invalid input.");}
%%

int yywrap(void){
	return 1;
}

