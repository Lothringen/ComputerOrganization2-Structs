#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "matriz_lista_string.h"

void test_ejemploInt(FILE *pfile){
	integer_t* i;

	i = intNew();

	intPrint(i,pfile);

	i = intSet(i,54);

	i = intSet(i,3);

	intPrint(i,pfile);

	fprintf(pfile,"\n");

	intRemove(i);

	intPrint(i,pfile);

  	intDelete(i);

	fprintf(pfile,"\n");
}

/*
void test_ejemploStr(FILE *pfile){
	string_t* s;

	string_t* s2;
	
	s = strNew();

	strPrint(s, pfile);

	s = strSet(s,"sarasa");

	strPrint(s, pfile);

	fprintf(pfile,"\n");

	s2 = strNew();

	s2 = strSet(s2,"ms");

	s = strAddLeft(s,s2);

	s2 = NULL;

	strPrint(s, pfile);

	fprintf(pfile,"\n");

	s = strRemove(s);

	strPrint(s, pfile);

	fprintf(pfile,"\n");

	s = strSet(s,"nuevaPalabra2");

	strPrint(s, pfile);

	fprintf(pfile,"\n");

	
	s2 = strSet(strNew(),"nuevaPalabra");

	int res = strCmp(s, s2);

	fprintf(pfile,"%d \n", res);

	strDelete(s);

	strDelete(s2);
}*/

/*test de lista*/
/*void test_ejemploList(FILE *pfile){
	list_t* l;
	list_t* l2;
	string_t* s;
	string_t* s2;
	string_t* s3;
	integer_t* i;

	l = listNew();

	listPrint(l,pfile);

	i = intNew();

	l = listAddFirst(l,i);	//agrego un nodo
	
	listPrint(l,pfile);

	l = listAddFirst(l, intNew());	//agrego otro nodo

	l = listAddLast(l,intNew());

	l2 = listNew();

	s = strNew();
	
	s =  strSet(s,"aabc");

	l2 = listAdd(l2,s,(funcCmp_t*)&strCmp);

	s2 = strNew();

	s2 = strSet(s2,"aab");

	l2 = listAdd(l2,s2,(funcCmp_t*)&strCmp);

	listPrint(l2,pfile);

	l2 = listRemoveFirst(l2);

	s2 = strNew();

	s2 = strSet(s2,"aab");

	l2 = listAdd(l2,s2,(funcCmp_t*)&strCmp);

	l2 = listRemoveLast(l2);

	s = strNew();
	
	s =  strSet(s,"aabc");
	
	l2 = listAdd(l2,s,(funcCmp_t*)&strCmp);

	s3 = strNew();
	
	s3 =  strSet(s3,"aabc");

	l2 = listRemove(l2,s3,(funcCmp_t*)&strCmp);
	
	listDelete(l2);

	

}

*/


void test_list(FILE *pfile){
	list_t* l;
	
	integer_t* i;

	integer_t* i2;
	
	l = listNew();

	listAddLast(l, intSet(intNew(), 34));

	listAddLast(l, intSet(intNew(), 42));

	listAddLast(l, intSet(intNew(), 13));

	listAddLast(l, intSet(intNew(), 44));

	listAddLast(l, intSet(intNew(), 58));

	listAddLast(l, intSet(intNew(), 11));

	listAddLast(l, intSet(intNew(), 92));

	listPrint(l, pfile);

	fprintf(pfile,"\n");

	i = intSet(intNew(), 13);

	listRemove(l, i , (funcCmp_t*)&intCmp);

	intDelete(i);

	i2 = intSet(intNew(), 58);	

	listRemove(l, i2 , (funcCmp_t*)&intCmp);

	intDelete(i2);

	listPrint(l, pfile);

	fprintf(pfile,"\n");

	listDelete(l);

}

void test_matriz(FILE *pfile){
	matrix_t* m;
	m = matrixNew(4,5);
	m = matrixAdd(m,0,0, intNew());
	m = matrixAdd(m,0,1, intNew());
	m = matrixAdd(m,0,2, intNew());
	m = matrixAdd(m,0,3, intNew());
	m = matrixAdd(m,0,4, intNew());
	m = matrixAdd(m,3,0, intNew());
	m = matrixAdd(m,3,1, intNew());

	m = matrixAdd(m,1,0,listAddFirst(listAddFirst(listAddFirst(listNew(),intSet(intNew(),3)),intSet(intNew(),2)), intSet(intNew(),1)));
	m = matrixAdd(m,2,0,listAddFirst(listAddFirst(listAddFirst(listNew(),strSet(strNew(),"SA")),strSet(strNew(),"RA")), strSet(strNew(),"SA")));
	m = matrixAdd(m,1,1,listAddFirst(listAddFirst(listAddFirst(listNew(),intSet(intNew(),3)),intSet(intNew(),2)), listNew()));
	m = matrixAdd(m,2,1,listAddFirst(listAddFirst(listAddFirst(listNew(),strSet(strNew(),"SA")),strSet(strNew(),"RA")), strSet(strNew(),"SA")));
	m = matrixAdd(m,1,2,listAddFirst(listAddFirst(listAddFirst(listNew(),intSet(intNew(),3)),listNew()), listNew()));
	m = matrixAdd(m,2,2,listAddFirst(listAddFirst(listAddFirst(listNew(),listAddFirst(listNew(), strSet(strNew(),"SA"))), listAddFirst(listNew(), strSet(strNew(),"RA"))), listAddFirst(listNew(), strSet(strNew(),"SA"))));
	m = matrixAdd(m,3,2,intSet(intNew(),35));
	m = matrixAdd(m,1,3,listAddFirst(listAddFirst(listAddFirst(listNew(),listAddFirst(listNew(), strSet(strNew(),"SA"))), listAddFirst(listNew(), strSet(strNew(),"RA"))), listAddFirst(listNew(), strSet(strNew(),"SA"))));
	m = matrixAdd(m,2,3,listAddFirst(listAddFirst(listAddFirst(listNew(),intSet(intNew(),3)),listAddFirst(listNew(),intSet(intNew(),2))), intSet(intNew(),1)));
	m = matrixAdd(m,3,3,intSet(intNew(),32));

	m = matrixAdd(m,1,4, listAddLast(listAddFirst(listNew(), 
	listAddLast(listAddFirst(listAddFirst(listNew(), strSet(strNew(),"ra")), strSet(strNew(),"ra")), intSet(intNew(),33))),
	listAddLast(listAddFirst(listAddFirst(listNew(), strSet(strNew(),"ro")), strSet(strNew(),"ro")), intSet(intNew(),35))) );
	m = matrixAdd(m,2,4,intSet(intNew(),8));
	m = matrixAdd(m,3,4,intSet(intNew(),31));

	matrixPrint(m,pfile);
	matrixDelete(m);
}






int main (void){
	FILE *pfile = fopen("salida.casos.propios.txt","w");
	//test_ejemploInt(pfile);
	//test_strings(pfile);
	test_list(pfile);	
	test_matriz(pfile);
/*test_ejemploStr(pfile);
	test_ejemploList(pfile);
	test_ejemploMatrix(pfile);*/
	//test_strings(pfile);
	
	
	fclose(pfile);
	return 0;    
}


