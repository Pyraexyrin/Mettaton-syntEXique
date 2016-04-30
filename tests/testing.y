%{

#include <stdio.h>
#include <string.h>
#include "syntax_tree.h"

#define YYDEBUG 1
//#define YYSTYPE char *

extern int yylex(void);

Tree tree;

%}



// Définit les espacements entre expressions : oblige à un [:space:] au minimum
// [:space:] = {" ", \t, \r, \n, \v, \f}
// space_alt peut être %empty

%token E_O_F TEXT_CONTENT ATTRIBUTE SPACE
%token XML_FREE_TEXT
%start init





%%



// Règle initiale

init 	: expr_set E_O_F 							{}
;

// Cas du fichier vide
// Puisque la balise <body> est posée, on suppose pouvoir mettre directement du texte

expr_set 	: expr_set SPACE expression 			{}
    		| expression 							{}
    		| %empty 								{}
;

// Expressions principales
// expression réductible en space ou en %empty

expression 	: marker 								{}
		   	| braces 								{}
		   	| text 									{}
;

// Balises

marker 	: XML_FREE_TEXT attributes end_of_marker	{/*
														tree = add_son_Tree(tree, $1);
													*/}
;

// Attributs

attributes 	: '[' attrib ']'					 	{}
	   		| %empty								{}
;

attrib 	: attrib ',' attrib_alt 					{}
		| attrib ',' SPACE attrib_alt 				{}
       	| attrib_alt								{}
;

attrib_alt	: text_content '=' text 				{/*
														char* str = malloc( sizeof( strlen($1)+strlen($2)+2 ) );
														strcpy(str, $1);
														strcat(str, "=\"");
														strcat(str, $2);
														add_attribute_Tree(tree, str);
													*/}
;

// Fin de balise
end_of_marker 	: braces 							{}
	      		| '/'								{}
;

// Accolades isolées (indépendantes d'une balise)
// Suffit par réductabilité d'expression

braces 	: '{' expr_set '}'							{}
;

// Texte simple

text 	: '"' text_content '"'						{}
;

text_content 	: TEXT_CONTENT 						{}
				| XML_FREE_TEXT						{}
;



%%



int
main(int argc, char ** argv){
	//if(argc>1)
	//	yyin=fopen(argv[1],"r");

	Tree root = create_Tree("init");
	tree = root;

	if(!yyparse())
		fprintf(stderr, "SUCCESSO\n");

	print_Tree(root);
	destroy_Tree(root);

	return(0);
}










