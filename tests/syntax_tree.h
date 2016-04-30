#ifndef SYNTAX_TREE_H_INCLUDED
#define SYNTAX_TREE_H_INCLUDED

typedef struct attribute_t * Attribute;
typedef struct tree_t * Tree;

/*/
 * TREE
 * Ces fonctions n'interviennent pas dans la gestion des Attributes.
 * Le char* donné en paramètre est géré par l'utilisateur (son allocation,
 * sa modification...). A voir si c'est le meilleur choix.
 * C'est de même pour les char* des Attributes.
/*/

// Create and destroy

Tree create_Tree(char* type);
void destroy_Tree(Tree);

// Interactions

Tree add_son_Tree(Tree, char* type);
Tree add_brother_Tree(Tree, char* type);

Tree get_son_Tree(Tree);
Tree get_brother_Tree(Tree);

// Printing

void print_Tree(Tree);

/*/
 * ATTRIBUTE
/*/

// Create and destroy

Attribute create_Attribute(char*);
void destroy_Attribute(Attribute);

// Interactions

const char* get_data_Attribute(Attribute);
Attribute get_next_Attribute(Attribute);

// Printing

void print_Attributes(Tree);

// Interactions with Trees

void add_attribute_Tree(Tree, char*);
Attribute get_attribute_Tree(Tree);

#endif // SYNTAX_TREE_H_INCLUDED
