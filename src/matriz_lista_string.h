#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <stdbool.h>
#include <unistd.h>

typedef enum e_type {
    NONE    = 0,
    INTEGER = 1,
    STRING  = 2,
    LIST    = 3,
    MATRIX  = 4,
} type_t;

typedef struct s_listElem{
    struct s_element *data;
    struct s_listElem *next;
} listElem_t;

typedef void (funcDelete_t)(void*);
typedef void (funcPrint_t)(void*, FILE *pFile);
typedef int32_t (funcCmp_t)(void*, void*);

typedef struct s_list{
    type_t dataType;
    funcDelete_t *remove;
    funcPrint_t *print;
    struct s_listElem *first;
} list_t;

typedef struct s_string{
    type_t dataType;
    funcDelete_t *remove;
    funcPrint_t *print;
    char *data;
} string_t;

typedef struct s_integer{
    type_t dataType;
    funcDelete_t *remove;
    funcPrint_t *print;
    int *data;
} integer_t;

typedef struct s_matrix{
    type_t dataType;
    funcDelete_t *remove;
    funcPrint_t *print;
    uint32_t m;
    uint32_t n;
    void **data;
} matrix_t;

/* Funciones: Matriz */

matrix_t* matrixNew(uint32_t m, uint32_t n);
matrix_t* matrixAdd(matrix_t* m, uint32_t x, uint32_t y, void* data);
matrix_t* matrixRemove(matrix_t* m, uint32_t x, uint32_t y);
void matrixDelete(matrix_t* m);
void matrixPrint(matrix_t* m, FILE *pFile);

/* Funciones: Lista */

list_t* listNew();
list_t* listAddFirst(list_t* l, void* data);
list_t* listAddLast(list_t* l, void* data);
list_t* listAdd(list_t* l, void* data, funcCmp_t* f);
list_t* listRemove(list_t* l, void* data, funcCmp_t* f);
list_t* listRemoveFirst(list_t* l);
list_t* listRemoveLast(list_t* l);
void listDelete(list_t* l);
void listPrint(list_t* l, FILE *pFile);

/* Funciones: String */

string_t* strNew();
string_t* strSet(string_t* s, char* c);
string_t* strAddRight(string_t* s, string_t* d);
string_t* strAddLeft(string_t* s, string_t* d);
string_t* strRemove(string_t* s);
void strDelete(string_t* s);
int32_t strCmp(string_t* a, string_t* b);
void strPrint(string_t* s, FILE *pFile);

/* Funciones: Entero */

integer_t* intNew();
integer_t* intSet(integer_t* i, int d);
integer_t* intRemove(integer_t* i);
void intDelete(integer_t* i);
int32_t intCmp(integer_t* a, integer_t* b);
void intPrint(integer_t* i, FILE *pFile);

