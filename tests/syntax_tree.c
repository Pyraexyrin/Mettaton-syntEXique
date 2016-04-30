#include <stdio.h>
#include <malloc.h>
#include "syntax_tree.h"

struct attribute_t {
    const char* data;
    Attribute next;
};

struct tree_t {
    const char* type;
    Tree father;
    Tree brother;
    Attribute attributes;
    Tree sons;
};

 //////////
 // TREE //
 //////////

// Create and destroy

Tree
create_Tree(char* type){
    Tree t = malloc(sizeof(struct tree_t));
    t->type = type;
    t->father = t->brother = t->sons = NULL;
    t->attributes = NULL;
    return t;
}

void
destroy_Tree(Tree t){
    if (!t) {
        fprintf(stderr, "destroy_Tree : NULL is not a correct parameter.\n");
        return;
    }
    if (t->sons)
        destroy_Tree(t->sons);
    if (t->brother)
        destroy_Tree(t->brother);
    if (t->attributes)
        destroy_Attribute(t->attributes);
    free(t);
}

// Interactions

Tree
add_son_Tree(Tree t, char* type){
    if (!t) {
        fprintf(stderr, "add_son_Tree : NULL is not a correct parameter.\n");
        return NULL;
    }

    Tree tmp = create_Tree(type);

    if (!(t->sons))
        t->sons = tmp;

    else {
        t = t->sons;
        while (t->brother)
            t = t->brother;
        t->brother = tmp;
    }

    return tmp;
}

Tree
add_brother_Tree(Tree t, char* type){
    if (!t) {
        fprintf(stderr, "add_brother_Tree : NULL is not a correct parameter.\n");
        return NULL;
    }

    Tree tmp = create_Tree(type);

    while (t->brother) {
        t = t->brother;
    }
    t->brother = tmp;

    return tmp;
}

Tree
get_son_Tree(Tree t){
    if (!t) {
        fprintf(stderr, "get_son_Tree : NULL is not a correct parameter.\n");
        return NULL;
    }
    return t->sons;
}

Tree
get_brother_Tree(Tree t){
    if (!t) {
        fprintf(stderr, "get_brother_Tree : NULL is not a correct parameter.\n");
        return NULL;
    }
    return t->brother;
}

// Printing

void
recursive_print_Tree(Tree t, int n){
    for (int i = 0 ; i<n; ++i)
        printf(" ");
    printf(" %s : ", t->type);
    print_Attributes(t);
}

void print_Tree(Tree t){
    if (!t) {
        fprintf(stderr, "print_Tree : NULL is not a correct parameter.\n");
        return;
    }
    recursive_print_Tree(t, 0);
}

 ///////////////
 // ATTRIBUTE //
 ///////////////

// Create and destroy

Attribute
create_Attribute (char* attribute){
    Attribute a = malloc(sizeof(struct attribute_t));
    a->data = attribute;
    a->next = NULL;
    return a;
}

void
destroy_Attribute(Attribute a){
    if (!a) {
        fprintf(stderr, "destroy_Attribute : NULL is not a correct parameter.\n");
        return;
    }
    if (a->next)
        destroy_Attribute(a->next);
    free(a);
}

// Interactions

const char*
get_data_Attribute (Attribute a){
    if (!a) {
        fprintf(stderr, "get_data_Attribute : NULL is not a correct parameter.\n");
        return NULL;
    }
    return a->data;
}

Attribute
get_next_Attribute(Attribute a){
    if (!a) {
        fprintf(stderr, "get_next_Attribute : NULL is not a correct parameter.\n");
        return NULL;
    }
    return a->next;
}

// Printing

void
print_Attribute(Attribute a){
    printf("<%s> ", get_data_Attribute(a));
}

void
print_Attributes(Tree t){
    if (!t) {
        fprintf(stderr, "print_Attributes : NULL is not a correct parameter.\n");
        return;
    }
    Attribute a = get_attribute_Tree(t);
    while (a){
        print_Attribute(a);
        a = get_next_Attribute(a);
    }
    printf("\n");
}

// Interactions with Trees

void
add_attribute_Tree(Tree t, char* data){
    if (!t) {
        fprintf(stderr, "add_attribute_Tree : NULL is not a correct parameter.\n");
        return;
    }
    Attribute a = create_Attribute(data);
    if (!t->attributes)
        t->attributes = a;
    else {
        Attribute tmp = t->attributes;
        while (tmp->next)
            tmp = tmp->next;
        tmp->next = a;
    }
}

Attribute
get_attribute_Tree(Tree t){
    if (!t) {
        fprintf(stderr, "get_attribute_Tree : NULL is not a correct parameter.\n");
        return NULL;
    }
    return t->attributes;
}
