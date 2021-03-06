#ifndef __NODE_H__
#define __NODE_H__

#include<assert.h>
#include<stdarg.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include "enum.h"

#define TRUE 1
#define FALSE 0

// node type declaration
typedef struct node {
    int lineNo;             // line no.
    size_t strLen;          // length of strVal
    NodeType type;          // node type
    char* name;             // node name
    unsigned int counted;   // counted before or not
    union                   // node value
    {
        int intVal;
        float floatVal;
        char* strVal;
    };

    struct node* child; // first child node of non-terminal node
    struct node* next;  // next brother node of non-terminal node
}Node;

typedef Node* pNode;

/**
 * @brief create a new grammar tree node
 * @param yytext: set yytext to NULL if creating a new grammar tree node,
 *                  set yytext to str value when creating a lex node
 */
static inline pNode newNode(int lineNo, NodeType type, char* name, char* yytext, int argc, ...){
    // printf("%s\n", name);
    pNode curNode = NULL;
    int nameLength = strlen(name) + 1;

    curNode = (pNode)malloc(sizeof(Node));

    assert(curNode!=NULL);

    curNode -> name = (char*)malloc(sizeof(char)*nameLength);

    assert(curNode->name!=NULL);

    curNode->lineNo = lineNo;
    curNode->type = type;
    strncpy(curNode->name, name, nameLength);

    if (type==TOKEN_INT)
    {
        if(yytext)  curNode->intVal=atoi(yytext);
    }else if (type==TOKEN_FLOAT)
    {
        curNode->floatVal=atof(yytext);
    }else if (type==TOKEN_OTHER)
    {
        curNode->strVal = yytext;
        curNode->strLen=strlen(yytext);
    }else{
        char wMsg[] = "Not a token";
        curNode->strVal=wMsg;
    }

    if(argc>0){
        va_list vaList;
        va_start(vaList, argc);
        
        pNode tempNode = va_arg(vaList, pNode);

        curNode->child = tempNode;

        for(int i=1;i<argc;i++){
            tempNode->next=va_arg(vaList, pNode);
            if(tempNode->next!=NULL){
                tempNode = tempNode->next;
            }
        }

        va_end(vaList);
    }
    return curNode;
}

static inline pNode newTokenNode(int lineNo, NodeType type, char* name, char* yytext){
    return newNode(lineNo, type, name, yytext,  0);
}

static inline void delNode(pNode node){
    if (node==NULL)
    {
        return;
    }

    while(node->child!=NULL){  // recursively delete child nodes
        pNode temp = node ->child;
        node->child = node->child->next;
        delNode(temp);
    }
    free(node->name);
    node=NULL;
}

static inline void printTreeInfo(pNode curNode, int height){
    if(curNode==NULL)   return;

    for(int i=0;i<height;i++){
        printf("    ");
    }
    printf("%s", curNode->name);
    if(curNode->type==NOT_A_TOKEN){
        printf(" (%lf)", curNode->floatVal);
    }else if(curNode->type==TOKEN_INT||curNode->type==TOKEN_FLOAT){
        printf(": %lf", curNode->floatVal);
    }
    printf("\n");
    printTreeInfo(curNode->child, height+1);
    printTreeInfo(curNode->next, height);
}

#endif