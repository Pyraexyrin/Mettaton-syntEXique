%{
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
int fileno(FILE *stream);
FILE* fichier = NULL;

char label[20];
char label2[10];
char * caract;

int under_t=0;

%}
%option noyywrap noinput nounput
%x TREE
%x TEXT
%x ATTRIBUTE
%x UNDER_TREE
%x BALISE

%%
"{"				{fputs("<", fichier);BEGIN BALISE;}
[[:alpha:]]			{fputs("<", fichier);caract=&yytext[0];strcat(label,caract);fputs(caract,fichier);BEGIN BALISE;}
"}"				;

<BALISE>[[:alpha:]]		{caract=&yytext[0];strcat(label,caract);fputs(caract, fichier);}
<BALISE>"{"			{fputs(">", fichier);BEGIN TREE;}
<BALISE>"["			{fputs(" ",fichier);BEGIN ATTRIBUTE;}

<TREE>["]			{BEGIN TEXT;}
<TREE>"{"			;
<TREE>[[:space:]]		{fputs(" ",fichier);}
<TREE>[[:alpha:]]		{fputs("<", fichier);caract=&yytext[0];strcat(label2,caract);fputs(caract,fichier);under_t=1;BEGIN UNDER_TREE;}
<TREE>"}"			{fputs("</", fichier);fputs(label, fichier);fputs(">", fichier);for(int i=0;i<sizeof(label);i++){label[i]=NULL;}BEGIN INITIAL;}
<TREE>"["			{BEGIN ATTRIBUTE;}

<UNDER_TREE>[[:alpha:]]		{caract=&yytext[0];strcat(label2,caract);fputs(caract, fichier);}
<UNDER_TREE>"["			{fputs(" ",fichier);BEGIN ATTRIBUTE;}
<UNDER_TREE>"{"			;
<UNDER_TREE>["]			{BEGIN TEXT;}
<UNDER_TREE>"}"			{fputs("</", fichier);fputs(label2, fichier);fputs(">", fichier);under_t=0;for(int i=0;i<sizeof(label2);i++){label2[i]=NULL;}BEGIN TREE;}
<UNDER_TREE>"/"			{fputs("/>", fichier);under_t=0;BEGIN TREE;}

<TEXT>[[:alnum:]]|[[:space:]]|"."	{fputs(&yytext[0], fichier);}
<TEXT>["]				{if(under_t==1){BEGIN UNDER_TREE;}
					 else{BEGIN TREE;}}

<ATTRIBUTE>[[:alpha:]]|["]|"="|"."|[[:space:]]	{fputs(&yytext[0], fichier);}
<ATTRIBUTE>"]"					{fputs(">", fichier);
						 if(under_t==1){BEGIN UNDER_TREE;}
						 else{BEGIN TREE;}}




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


