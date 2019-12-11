#include "matriz_lista_string.h"

matrix_t* _matrixNew(uint32_t m, uint32_t n){
    return 0;
}

void matrixPrint(matrix_t* m, FILE *pFile) {
	int tam = m->m * m->n;
	integer_t *data;
	for(int i =0; i<tam; i++){
		if(i % m->m == 0){
			fprintf(pFile, "|");
		}	
		data = (integer_t*) m->data[i];		//lo casteo a puntero a entero
		if(data == NULL){
			fprintf(pFile, "NULL");
		}else{
			data->print(data, pFile);
		} 
		fprintf(pFile, "|");
		if(i % m->m == m->m -1){
			fprintf(pFile, "\n");
		}
	}
	

}

