%{
    int yywrap() {
        return 0;
    }
%}

%{

#include <stdio.h>

#include "y.tab.h"

%}

%%

[1-9]                               {yylval = atoi(yytext); return T_BLOCK_NUMBER;}
Robot[ ]please                      {return T_ROBOT_PLEASE;}
turn                                {return T_TURN;}
move                                {return T_MOVE;}
degrees                             {return T_DEGREES;}
90|180|270|360                      {yylval = atoi(yytext); return T_DEGREE_NUMBER;}
(and|,)?[ ]then                     {return T_THEN;}
[\t \s]                             ;
blocks|block                        {return T_BLOCKS;}
(\n|\r\n|\r)                        {return T_NEWLINE;}
.                                   {return T_OTHER;}

%%
