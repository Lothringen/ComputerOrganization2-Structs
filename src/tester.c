#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <stdbool.h>

#include "matriz_lista_string.h"

#define RUN(filename, action) pfile=fopen(filename,"a"); action; fclose(pfile);
#define N 50

char *filename_1 =  "salida.caso1.txt";
char *filename_2 =  "salida.caso2.txt";
char *filename_3 =  "salida.caso3.txt";
void test_1();
void test_2();
void test_3();

int main() {
	srand(12345);
	remove(filename_1);
	test_1();
	remove(filename_2);
	test_2();
	remove(filename_3);
	test_3(); 
	return 0;
}

/* test de enteros */
void test_only_integers(FILE *pfile){
	integer_t* i;
	fprintf(pfile,"INTEGER:Creo y borro\n");
	intDelete(intNew());
	i = intNew();
	intPrint(i,pfile); intDelete(i); fprintf(pfile,"\n");
	fprintf(pfile,"INTEGER:Creo, seteo y borro\n");
	intDelete(intSet(intNew(),54));
	i = intSet(intNew(),54);
	intPrint(i,pfile); intDelete(i); fprintf(pfile,"\n");
	fprintf(pfile,"INTEGER:Creo, seteo, seteo y borro\n");
	intDelete(intSet(intSet(intNew(),54),24));
	i = intSet(intSet(intNew(),54),24);
	intPrint(i,pfile); intDelete(i); fprintf(pfile,"\n");
	fprintf(pfile,"INTEGER:Creo, seteo, remove, seteo y borro\n");
	intDelete(intSet(intRemove(intSet(intNew(),54)),34));
	i = intSet(intRemove(intSet(intNew(),54)),34);
	intPrint(i,pfile); intDelete(i); fprintf(pfile,"\n");
}

/* test de string */
void test_strings(FILE *pfile){
	string_t* s;
	fprintf(pfile,"STRING:Creo y borro\n");
	strDelete(strNew());
	s = strNew();
	strPrint(s,pfile); strDelete(s); fprintf(pfile,"\n");
	fprintf(pfile,"STRING:Creo, seteo y borro\n");
	strDelete(strSet(strNew(),"sarasa"));
	s = strSet(strNew(),"sarasa");
	strPrint(s,pfile); strDelete(s); fprintf(pfile,"\n");
	fprintf(pfile,"STRING:Creo, seteo, seteo y borro\n");
	strDelete(strSet(strSet(strNew(),"sarasa"),"massarasa"));
	s = strSet(strSet(strNew(),"sarasa"),"massarasa");
	strPrint(s,pfile); strDelete(s); fprintf(pfile,"\n");
	fprintf(pfile,"STRING:Creo, seteo, remove, seteo y borro\n");
	strDelete(strSet(strRemove(strSet(strNew(),"sarasa")),"massarasa"));
	s = strSet(strRemove(strSet(strNew(),"sarasa")),"massarasa");
	strPrint(s,pfile); strDelete(s); fprintf(pfile,"\n");
	fprintf(pfile,"STRING:Creo, seteo, addRight y borro\n");
	strDelete(strAddRight(strSet(strNew(),"sarasa"), strSet(strNew(),"ACA")));
	s = strAddRight(strSet(strNew(),"sarasa"), strSet(strNew(),"ACA"));
	strPrint(s,pfile); strDelete(s); fprintf(pfile,"\n");
	fprintf(pfile,"STRING:Creo, seteo, addLeft y borro\n");
	strDelete(strAddLeft(strSet(strNew(),"sarasa"), strSet(strNew(),"ACA")));
	s = strAddLeft(strSet(strNew(),"sarasa"), strSet(strNew(),"ACA"));
	strPrint(s,pfile); strDelete(s); fprintf(pfile,"\n");
	fprintf(pfile,"STRING:Creo, seteo, addRight, addLeft (el mismo) y borro\n");
	s = strSet(strNew(),"<->");
	s = strAddLeft(s,s);
	s = strAddRight(s,s);
	strPrint(s,pfile); strDelete(s); fprintf(pfile,"\n");
}

/* test de lista */
void test_ony_list(FILE *pfile){
	list_t* l;
	string_t* s;
	integer_t* i;
	fprintf(pfile,"LIST:Creo y borro\n");
	listDelete(listNew());
	l = listNew();
	listPrint(l,pfile); listDelete(l); fprintf(pfile,"\n");
	fprintf(pfile,"LIST:Creo, first y borro\n");
	listDelete(listAddFirst(listNew(),intNew()));
	l = listAddFirst(listNew(),intNew());
	listPrint(l,pfile); listDelete(l); fprintf(pfile,"\n");
	fprintf(pfile,"LIST:Creo, first, first y borro\n");
	listDelete(listAddFirst(listAddFirst(listNew(),intNew()),intNew()));
	l = listAddFirst(listAddFirst(listNew(),intNew()),intNew());
	listPrint(l,pfile); listDelete(l); fprintf(pfile,"\n");
	fprintf(pfile,"LIST:Creo, first, first remove, first y borro\n");
	listDelete(listAddFirst(listRemoveFirst(listAddFirst(listNew(),intNew())),intNew()));
	l = listAddFirst(listRemoveFirst(listAddFirst(listNew(),intNew())),intNew());
	listPrint(l,pfile); listDelete(l); fprintf(pfile,"\n");
	fprintf(pfile,"LIST:Creo, first, first remove, first remove y borro\n");
	listDelete(listRemoveFirst(listRemoveFirst(listAddFirst(listNew(),intNew()))));
	l = listRemoveFirst(listRemoveFirst(listAddFirst(listNew(),intNew())));
	listPrint(l,pfile); listDelete(l); fprintf(pfile,"\n");
	fprintf(pfile,"LIST:Creo, last y borro\n");
	listDelete(listAddLast(listNew(),intNew()));
	l = listAddLast(listNew(),intNew());
	listPrint(l,pfile); 
	listDelete(l); 
	fprintf(pfile,"\n");
	fprintf(pfile,"LIST:Creo, last, last y borro\n");
	listDelete(listAddLast(listAddLast(listNew(),intNew()),intNew()));
	l = listAddLast(listAddLast(listNew(),intNew()),intNew());
	listPrint(l,pfile); listDelete(l); fprintf(pfile,"\n");
	fprintf(pfile,"LIST:Creo, last, last remove, last y borro\n");
	listDelete(listAddLast(listRemoveLast(listAddLast(listNew(),intNew())),intNew()));
	l = listAddLast(listRemoveLast(listAddLast(listNew(),intNew())),intNew());
	listPrint(l,pfile); listDelete(l); fprintf(pfile,"\n");
	fprintf(pfile,"LIST:Creo, last, last remove, last remove y borro\n");
	listDelete(listRemoveLast(listRemoveLast(listAddLast(listNew(),intNew()))));
	l = listRemoveLast(listRemoveLast(listAddLast(listNew(),intNew())));
	listPrint(l,pfile); listDelete(l); fprintf(pfile,"\n");
	fprintf(pfile,"LIST:Creo, 4x str add, 5x remove y borro\n");
	l = listNew();
	l = listAdd(l,strSet(strNew(),"aabc"),(funcCmp_t*)&strCmp); listPrint(l,pfile); fprintf(pfile,"\n");
	l = listAdd(l,strSet(strNew(),"aab" ),(funcCmp_t*)&strCmp); listPrint(l,pfile); fprintf(pfile,"\n");
	l = listAdd(l,strSet(strNew(),"aaaa"),(funcCmp_t*)&strCmp); listPrint(l,pfile); fprintf(pfile,"\n");
	l = listAdd(l,strSet(strNew(),"zz"  ),(funcCmp_t*)&strCmp); listPrint(l,pfile); fprintf(pfile,"\n");
	s = strSet(strNew(),"aabc"); listRemove(l,(void*)s,(funcCmp_t*)&strCmp); strDelete(s);
	listPrint(l,pfile); fprintf(pfile,"\n");
	s = strSet(strNew(),"aaaa"); listRemove(l,(void*)s,(funcCmp_t*)&strCmp); strDelete(s);
	listPrint(l,pfile); fprintf(pfile,"\n");
	s = strSet(strNew(),"SA"  ); listRemove(l,(void*)s,(funcCmp_t*)&strCmp); strDelete(s);
	listPrint(l,pfile); fprintf(pfile,"\n");
	s = strSet(strNew(),"zz"  ); listRemove(l,(void*)s,(funcCmp_t*)&strCmp); strDelete(s);
	listPrint(l,pfile); fprintf(pfile,"\n");
	s = strSet(strNew(),"aab" ); listRemove(l,(void*)s,(funcCmp_t*)&strCmp); strDelete(s);
	listPrint(l,pfile); fprintf(pfile,"\n");
	listDelete(l);
	fprintf(pfile,"LIST:Creo, 4x int add, 5x remove y borro\n");
	l = listNew();
	l = listAdd(l,intSet(intNew(),842),(funcCmp_t*)&intCmp); listPrint(l,pfile); fprintf(pfile,"\n");
	l = listAdd(l,intSet(intNew(),942),(funcCmp_t*)&intCmp); listPrint(l,pfile); fprintf(pfile,"\n");
	l = listAdd(l,intSet(intNew(),331),(funcCmp_t*)&intCmp); listPrint(l,pfile); fprintf(pfile,"\n");
	l = listAdd(l,intSet(intNew(),223),(funcCmp_t*)&intCmp); listPrint(l,pfile); fprintf(pfile,"\n");
	i = intSet(intNew(),223); listRemove(l,(void*)i,(funcCmp_t*)&intCmp); intDelete(i);
	listPrint(l,pfile); fprintf(pfile,"\n");
	i = intSet(intNew(),842); listRemove(l,(void*)i,(funcCmp_t*)&intCmp); intDelete(i);
	listPrint(l,pfile); fprintf(pfile,"\n");
	i = intSet(intNew(),999); listRemove(l,(void*)i,(funcCmp_t*)&intCmp); intDelete(i);
	listPrint(l,pfile); fprintf(pfile,"\n");
	i = intSet(intNew(),331); listRemove(l,(void*)i,(funcCmp_t*)&intCmp); intDelete(i);
	listPrint(l,pfile); fprintf(pfile,"\n");
	i = intSet(intNew(),842); listRemove(l,(void*)i,(funcCmp_t*)&intCmp); intDelete(i);
	listPrint(l,pfile); fprintf(pfile,"\n");
	listDelete(l);
}

/* test de matriz */
void test_only_matrix(FILE *pfile){
	matrix_t* m;
	fprintf(pfile,"MATRIX:Creo, 1x1, int y borro\n");
	m = matrixNew(1,1);
	m = matrixAdd(m,0,0,intSet(intNew(),41));
	matrixPrint(m,pfile); matrixDelete(m);
	fprintf(pfile,"MATRIX:Creo, 2x2, int y borro\n");
	m = matrixNew(2,2);
	m = matrixAdd(m,1,0,intSet(intNew(),41)); matrixPrint(m,pfile);
	m = matrixAdd(m,0,1,intSet(intNew(),42)); matrixPrint(m,pfile);
	m = matrixAdd(m,0,0,intSet(intNew(),44)); matrixPrint(m,pfile);
	m = matrixAdd(m,1,1,intSet(intNew(),45)); matrixPrint(m,pfile);
	m = matrixAdd(m,0,0,intSet(intNew(),46)); matrixPrint(m,pfile);
	m = matrixAdd(m,1,1,intSet(intNew(),40)); matrixPrint(m,pfile);
	matrixDelete(m);
	fprintf(pfile,"MATRIX:Creo, 5x8, int/str y borro\n");
	m = matrixNew(5,8);
	m = matrixAdd(m,1,0,intSet(intNew(),10));
	m = matrixAdd(m,4,0,intSet(intNew(),40));
	m = matrixAdd(m,1,6,intSet(intNew(),16));
	m = matrixAdd(m,1,7,intSet(intNew(),17));
	m = matrixAdd(m,3,4,intSet(intNew(),34));
	matrixPrint(m,pfile);
	m = matrixAdd(m,1,1,strSet(strNew(),"11"));
	m = matrixAdd(m,0,1,strSet(strNew(),"SA"));
	m = matrixAdd(m,1,0,strSet(strNew(),"RA"));
	m = matrixAdd(m,1,1,strSet(strNew(),"SA"));
	m = matrixAdd(m,1,1,strSet(strNew(),"SA"));
	m = matrixAdd(m,4,5,strSet(strNew(),"LI"));
	m = matrixAdd(m,3,7,strSet(strNew(),"TO"));
	matrixPrint(m,pfile);
	matrixDelete(m);
	fprintf(pfile,"MATRIX:Creo, 2x4, list y borro\n");
	m = matrixNew(2,4);
	m = matrixAdd(m,0,2, listAddFirst(listNew(),intSet(intNew(),10)) );
	m = matrixAdd(m,1,3, listAddFirst(listAddFirst(listNew(),intSet(intNew(),10)),intSet(intNew(),82)) );
	m = matrixAdd(m,1,0, listAddLast(listAddFirst(listAddFirst(listNew(),intSet(intNew(),10)),intSet(intNew(),82)),intSet(intNew(),22)) );
	m = matrixAdd(m,0,0,intSet(intNew(),17));
	m = matrixAdd(m,1,1,intSet(intNew(),34));
	matrixPrint(m,pfile);
	m = matrixAdd(m,0,0,strSet(strNew(),"11"));
	m = matrixAdd(m,1,0,strSet(strNew(),"SA"));
	m = matrixAdd(m,0,1,strSet(strNew(),"RA"));
	m = matrixAdd(m,1,1,strSet(strNew(),"SA"));
	m = matrixAdd(m,0,2,strSet(strNew(),"SA"));
	m = matrixAdd(m,1,2,strSet(strNew(),"LI"));
	m = matrixAdd(m,0,3,strSet(strNew(),"TO"));
	matrixPrint(m,pfile);
	matrixDelete(m);
}

void test_1(char* filename){
	FILE *pfile;
	RUN(filename,test_only_integers(pfile););
	RUN(filename,test_strings(pfile););
	RUN(filename,test_ony_list(pfile););
	RUN(filename,test_only_matrix(pfile););
}

void test_2(char* filename){
	FILE *pfile;
	char *a[10] = {"a","b","1234","ffff","oiuytre","dfsd","sss","qwwww","pp","PP"};
	list_t* l;
	l = listNew();
	for(int i=0; i<N; i++) {
		list_t *ll = listNew();
		for(int j=0; j<N; j++) {
			listAddFirst(ll,intSet(intNew(),rand()%1000));
			listAdd(ll,intSet(intNew(),rand()%1000),(funcCmp_t*)&intCmp);
			listAddLast(ll,intSet(intNew(),rand()%1000));
		}
		listAddFirst(l,ll);
		ll = listNew();
		for(int j=0; j<N; j++) {
			listAddFirst(ll,intSet(intNew(),rand()%1000));
			listAdd(ll,intSet(intNew(),rand()%1000),(funcCmp_t*)&intCmp);
			listAddLast(ll,intSet(intNew(),rand()%1000));
		}
		listAddLast(l,ll);
		RUN(filename,listPrint(l,pfile););
	}
	listDelete(l);
	l = listNew();
	for(int i=0; i<N; i++) {
		list_t *ll = listNew();
		for(int j=0; j<N; j++) {
			listAddFirst(ll,strSet(strNew(),a[rand()%10]));
			listAdd(ll,strSet(strNew(),a[rand()%10]),(funcCmp_t*)&strCmp);
			listAddLast(ll,strSet(strNew(),a[rand()%10]));
		}
		listAddFirst(l,ll);
		ll = listNew();
		for(int j=0; j<N; j++) {
			listAddFirst(ll, strAddLeft(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) );
			listAdd(ll, strAddRight(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) ,(funcCmp_t*)&strCmp);
			listAddLast(ll, strAddLeft(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) );
		}
		listAddLast(l,ll);
		RUN(filename,listPrint(l,pfile););
	}
	listDelete(l);
}

void test_3(char* filename){
	FILE *pfile;
	char *a[10] = {"111","222","rtsd","igfjrg","snqqq","qq","opf3","envrb","SASAS","urs"};
	list_t* l;
	matrix_t* m = matrixNew(10,15);
	for(int i=0; i<N; i++) {
		for(int j=0; j<N/2; j++) {
			matrixAdd(m,rand()%10,rand()%15, intSet(intNew(),rand()%10) );
			matrixAdd(m,rand()%10,rand()%15, intSet(intNew(),rand()%10) );
			matrixAdd(m,rand()%10,rand()%15, intSet(intNew(),rand()%10) );
		}
		RUN(filename,matrixPrint(m,pfile););
	}
	for(int i=0; i<N; i++) {
		for(int j=0; j<N/2; j++) {
			matrixAdd(m,rand()%10,rand()%15, strAddLeft(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) );
			matrixAdd(m,rand()%10,rand()%15, strAddRight(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) );
			matrixAdd(m,rand()%10,rand()%15, strAddLeft(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) );
		}
		RUN(filename,matrixPrint(m,pfile););
	}
	for(int i=0; i<N; i++) {
		list_t *ll = listNew();
		for(int j=0; j<N/2; j++) {
			listAddFirst(ll, strAddLeft(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) );
			listAdd(ll, strAddRight(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) ,(funcCmp_t*)&strCmp);
			listAddLast(ll, strAddLeft(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) );
		}
		matrixAdd(m,rand()%10,rand()%15,ll);
		RUN(filename,matrixPrint(m,pfile););
	}
	l = listNew();
	for(int i=0; i<N; i++) {
		list_t *ll = listNew();
		for(int j=0; j<N; j++) {
			listAddFirst(ll,intSet(intNew(),rand()%1000));
			listAdd(ll,intSet(intNew(),rand()%1000),(funcCmp_t*)&intCmp);
			listAddLast(ll,intSet(intNew(),rand()%1000));
		}
		listAddFirst(l,ll);
		RUN(filename,matrixPrint(m,pfile););
	}
	matrixAdd(m,rand()%10,rand()%15,l);
	l = listNew();
	for(int i=0; i<N; i++) {
		list_t *ll = listNew();
		for(int j=0; j<N; j++) {
			listAddFirst(ll, strAddLeft(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) );
			listAdd(ll, strAddRight(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) ,(funcCmp_t*)&strCmp);
			listAddLast(ll, strAddLeft(strSet(strNew(),a[rand()%10]),strSet(strNew(),a[rand()%10])) );
		}
		listAddLast(l,ll);
		RUN(filename,matrixPrint(m,pfile););
	}
	matrixAdd(m,rand()%10,rand()%15,l);
	RUN(filename,matrixPrint(m,pfile););
	matrixDelete(m);
}
