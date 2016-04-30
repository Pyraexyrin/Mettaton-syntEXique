%{

#include <stdio.h>
#include "testing.tab.h"

%}



LETTER 		[[:upper:][:lower:]]
INNER		[[:upper:][:lower:]0-9._]
XML_FREE_A 	{LETTER}{INNER}*
XML_FREE_B 	_{INNER}*

%x STRING




%%




<<EOF>>							{fprintf(stdout, "<<EOF>>"); return E_O_F;}
[[:space:]]+					{fprintf(stdout, "[:space:]");}
[xX][mM][lL][^"\""]*			{fprintf(stdout, "XML_TEXT");}
{XML_FREE_A}					{fprintf(stdout, "XML_FREE_TEXT");}
{XML_FREE_B}					{fprintf(stdout, "XML_FREE_TEXT");}




%%



/*
int
main (int argc, char ** argv) {

	yylex();
	fprintf(stdout, "\n"); 
	return 0;

}
*/