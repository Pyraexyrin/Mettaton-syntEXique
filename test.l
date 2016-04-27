%{
#include <stdio.h>
#include <stdlib.h>
int fileno(FILE *stream);
FILE* fichier = NULL;

%}
%option noyywrap noinput nounput
%x DIV
%x LETTRE
%x BALISE
%x BALISE_FIN
%x BALISE_OR
%x BALISE_OR_FIN


%%
"div{"	        			{BEGIN DIV;fputs("<div> \n	", fichier);}
<DIV>"}"				{BEGIN INITIAL;fputs("\n</div> \n", fichier);}
<DIV>[[:alpha:]]			{BEGIN BALISE;fputs("<", fichier);fputs(&yytext[0], fichier);}
<DIV>["]    				{BEGIN LETTRE;}

<LETTRE>[[:alnum:]]|[[:space:]]		{fputs(&yytext[0], fichier);}
<LETTRE>"à"				{fputs("à",fichier);}
<LETTRE>"."				{fputs(".",fichier);}
<LETTRE>["]				{BEGIN DIV;}

<BALISE>[[:alpha:]]|[[:space:]]|["]|"="|"."|\n	{fputs(&yytext[0], fichier);}
<BALISE>"/"					{fputs(&yytext[0], fichier);fputs(">", fichier);BEGIN DIV;}
<BALISE>"["					{fputs(" ", fichier);}
<BALISE>"]"					{fputs(">", fichier);BEGIN BALISE_FIN;}

<BALISE_FIN>["]|"{"			;
<BALISE_FIN>[[:alpha:]]			{fputs(&yytext[0],fichier);}
<BALISE_FIN>"}"				{fputs("</>",fichier);BEGIN DIV;}

[[:alpha:]]"["			{BEGIN BALISE_OR;fputs("<", fichier);fputs(&yytext[0], fichier);}

<BALISE_OR>[[:alpha:]]|[[:space:]]|["]|"="|"."|\n	{fputs(&yytext[0], fichier);}
<BALISE_OR>"/"						{fputs(&yytext[0], fichier);fputs(">", fichier);BEGIN DIV;}
<BALISE_OR>"["						{fputs(" ", fichier);}
<BALISE_OR>"]"						{fputs(">", fichier);BEGIN BALISE_OR_FIN;}

<BALISE_OR_FIN>["]|"{"			;
<BALISE_OR_FIN>[[:alpha:]]			{fputs(&yytext[0],fichier);BEGIN INITIAL;}
<BALISE_OR_FIN>"}"				{fputs("</>",fichier);BEGIN INITIAL;}

[[:alnum:]]|[[:space:]]		{fputs(&yytext[0], fichier);}
["]"}"				{fputs("</>",fichier);}
"{"|["]|"}"|"."				;



%%

int main (void){
	
	fichier = fopen("test_2.html", "w");
	fputs("<!DOCTYPE html> \n ", fichier);
	fputs("<html> \n ", fichier);
	fputs("<head> \n ", fichier);
	fputs("<meta charset=utf-8> \n",fichier);
	fputs("</head> \n ", fichier);
	fputs("<body> \n ", fichier);
	
	yylex();

	fputs("</body> \n ", fichier);
	fputs("</html> \n ",fichier);
	fclose(fichier);
	
	return 0;
 }

