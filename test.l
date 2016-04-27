%{
#include <stdio.h>
#include <stdlib.h>
int fileno(FILE *stream);
FILE* fichier = NULL;

%}
%option noyywrap noinput nounput
%x DIV


%%
"div{"	        	{BEGIN DIV;fputs("<div> \n	", fichier);}
<DIV>[[:alpha:]]    	{fputs(&yytext[0], fichier);}
<DIV>./n		;
<DIV>"}"		{BEGIN INITIAL;fputs("\n</div> \n", fichier);}


[ \t]           ;
\n		{return yytext[0];}
.		{return yytext[0];}
%%

int main (void){
	
	fichier = fopen("test_2.txt", "r+");
	fputs("<!DOCTYPE html> \n ", fichier);
	fputs("<html> \n ", fichier);
	fputs("<head> \n ", fichier);
	fputs("</head> \n ", fichier);
	fputs("<body> \n ", fichier);
	
	yylex();

	fputs("</body> \n ", fichier);
	fputs("</html> \n ", fichier);
	fclose(fichier);
	
	return 0;
 }


