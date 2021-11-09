
%{
   
   #include<stdio.h>
   #include<stdlib.h>
   # include<stdarg.h>
   #include<string.h>
   #include<math.h>
   #include "munna.tab.h"
  
  

%}



%%
"begin"     {return MBEGIN;}
"end"       {return END;}
"import"    {return IMPORT;}

"m_int"    {return INTEGER;}
"m_float"  {return FLOAT;}
"m_char"   {return CHAR;}
"m_string" {return STRING;}


":"       {return COLON;}
";"       {return SEMICOLON;}
":="      {return ASSIGN;}
","       {return COMMA;}
"->"      {return FORWARD_ARROW;}
"<-"      {return BACKWARD_ARROW;}
"["       {return OTB;}
"]"       {return CTB;}
"^"       {return POW;}
"<<"      {return OP;}
">>"      {return CP;}
"<?"      {return LESS_THAN;}
">?"      {return GREATER_THAN;}
"<=?"     {return LESS_EQUAL;}
">=?"     {return GREATER_EQUAL;}
"=?"      {return EQUAL;}
"!=?"     {return NOT_EQUAL;}
"+"       {return FOR_INC;}
"-"       {return FOR_DEC;}
"{"       {return OSB;}
"}"       {return CSB;}
"$$"      {return AND;}
"@@"      {return OR;}

"show"    {return SHOW;}
"take"    {return TAKE;}
"either"  {return IF;}
"either or" {return ELSE_IF;}
"or"        {return ELSE;}
"for"      {return FOR;}
"in"      {return IN;}
"switch"   {return SWITCH;}
"*"        {return DEFAULT;}   
"while"    {return WHILE;}

"add"     {return PLUS;}
"sub"     {return SUB;}
"mult"    {return MULT;}
"div"     {return DIV;}
"mod"     {return MOD;}
"_sin"     {return SIN;}
"_cos"     {return COS;}
"_tan"     {return TAN;}
"_log10"   {return LOG10;}
"_log"     {return LOG;}


"_evenodd"  {return EVEN_ODD;}
"_factorial"  {return FACTORIAL;}
"_sum"  {return SUM;}
"_gcd"  {return GCD;}
"_lcm"  {return LCM;}

"#".*          {printf("\n\t\t\t\tSingle line comment\n");}
"##"[^#]+"##"  {printf("\n\t\t\t\tMulti line comment\n");}

[a-zA-Z][_a-zA-Z0-9]*  {yylval.variable = strdup(yytext); return VARIABLE;}
[-+]?[0-9]+            {yylval.intVal = atoi(yytext);  return INT_VAL;}
[-+]?[0-9]*\.?[0-9]+   {yylval.floatVal = atof(yytext); return FLOAT_VAL;}
[\'][a-zA-Z][\']       {yylval.charVal = yytext[1];    return CHAR_VAL;}
[\"](\\.|[^"])*[\"]    {
                        yylval.strVal = malloc(yyleng - 1);  
                        memcpy (yylval.strVal, yytext + 1, yyleng - 2); 
                        yylval.strVal[yyleng - 2] = 0;                 
                        return STRING_VAL;
					   }
[a-zA-Z0-9_]*".h"      {yylval.strVal = strdup(yytext); return HEADER;}


[ \t\n]+ ;

.   {
     yyerror("Unknown character\n");
    }


%%




