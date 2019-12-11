; FUNCIONES de C
	extern malloc
	extern free
	extern fopen
	extern fclose
	extern fprintf

section .data


formatM1: db "|", 0
formatM2: db  10 , 0  ; el 10 es el salto de linea y el 0 el delimitador
formatM3: db "NULL", 0

format1: db "[", 0
format2: db ",", 0
format3: db "]", 0

formatStr1:db "%s", 0
formatStr2:db "NULL", 0	

formatInt1: db "%d", 0		;db es define Byte es un Byte para cada uno de los caracteres, 0 es el delimitador
formatInt2: db "NULL", 0

section .text

global str_len
global str_copy
global str_cmp
global str_concat
global matrixNew
global matrixAdd
global matrixRemove
global matrixDelete
;global matrixPrint
global listNew
global listAddFirst
global listAddLast
global listAdd
global listRemove
global listRemoveFirst
global listRemoveLast
global listDelete
global listPrint
global strNew
global strSet
global strAddRight
global strAddLeft
global strRemove
global strDelete
global strCmp
global strPrint
global intNew
global intSet
global intRemove
global intDelete
global intCmp
global intPrint


%define NULL 0
%define INTEGER 1
%define STRING 2
%define LIST 3
%define MATRIX 4

%define offset_type 0		;los valores los pongo en bytes	
%define offset_remove 8		
%define offset_print 16
%define offset_dato 24		;para int y str
%define offset_prim 24  	;para lista
%define offset_m 24
%define offset_n 28
%define offset_datoM 32

;STRUCT NODO	
%define offset_data	0
%define offset_prox	8

%define SIZE_ENTERO 32
%define SIZE_STRING 32 
%define SIZE_LISTA 32
%define SIZE_NODO 16
%define SIZE_MATRIZ 40

%define UNO 1
%define OCHO 8
%define TRES 3
%define DWORD 32

%define INT_SIZE 4		;Un int tiene 4bytes de tamaño

;########### Funciones Auxiliares Recomendadas

; uint32_t str_len(char* a)
;En RDI = a 
str_len:
	;armo el stack frame
	push rbp ;PILA ALINEADA
	mov rbp, rsp	

	 
	xor eax, eax				;anulo el valor en eax no se que pudiera haber ahi antes, lo quiero usar como contador
	.ciclo:	
		cmp byte[rdi], NULL		;comparo el char con 0, si es cero llegue al delimitador y termino la palabra
		je .fin
		inc eax				;aumento en 1 la cantidad de chars que tiene el string		
		inc rdi				;me muevo una posicion de memoria hacia adelante incremento de a 1 byte que es la cantidad de memo que ocupa un char
		jmp .ciclo
	
	.fin:
		inc eax			;se incrementa en 1 mas porque el delimitador tambien cuenta como la longitud de la palabra, obtengo la longitud en bytes
		
	;desarmo el stack frame
	pop rbp
	ret

; char* str_copy(char* a)
; En RDI = a
str_copy:
	;armo el stack frame
	push rbp ;PILA ALINEADA
	mov rbp, rsp
	push rbx		;lo necesito para preservar el valor del puntero char* a
	push r12		;la utilizare de registro intermedio
	push r13		;lo utilizo para preservar el valor del puntero de la copia que esta en rax despues de llamar a malloc
	push r14		;lo utilizo para guardar la longitud de la palabra

	mov rbx, rdi	
	call str_len 	;en rdi ya tengo el valor del puntero a llamo a la funcion str_len  
	mov r14d, eax	;le cargo la longitud de la palabra
	mov eax, eax	;limpio la parte alta de rax
	mov rdi, rax	;le digo cuanta memoria quiero reservar, el resultado de str_len esta en rax 
	call malloc
	mov r13, rax 	;En rax esta la posicion de memoria donde empieza la copia lo guardo en r13

	xor rcx, rcx	;uso el contador rcx para el loop, primero lo reseteo
	mov ecx, r14d	;pongo en el contador, el valor de longitud de la palabra 
	.ciclo:
		mov r12b, [rbx]
		mov byte[r13], r12b
		inc rbx			;la posicion de memoria se incrementa en un byte  
		inc r13			;idem para la copia
		loop .ciclo	

	;desarmo el stack frame
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret

; int32_t str_cmp(char* a, char* b)
;En RDI = a, RSI = b
str_cmp:
	;armo el stack frame
	push rbp
	mov rbp, rsp
	push rbx
	sub rsp, 8 
	
	xor eax, eax		; seteo el registro de resultado eax (32bits) en cero
	cmp rdi, rsi		; si los dos punteros apuntan a la misma dirccion, entonces es el mismo string 
	je .fin

	.ciclo:	
		mov cl, [rdi]				;uso la parte baja de rcx, cl de 8bytes para guardar el contenido del char apuntado
		cmp cl, NULL
		je .termino_a
		mov cl, [rsi]
		cmp cl, NULL
		je .mayor 				;pero se que 'a' no termino, porque sino hubiera saltado antes y entonces a>b
		xor rbx,rbx
		mov bl, [rdi]				;tomo a rbx de variable intermedia para comparar, uso solo la parte baja 
		cmp bl, [rsi]		
		jg .mayor				
		jl .menor 
		inc rdi					;me muevo un byte hacia adelante en la memoria
		inc rsi
		jmp .ciclo
	
	.termino_a:
		mov cl, [rsi]
		cmp cl, NULL				;si pasa esto los dos strings son iguales 
		je .fin
		jmp .menor					;sino a era un substring de b y por lo tanto a<b 
	
	.mayor:
		dec eax						;eax = 0 - 1 = -1 caso a>b
		jmp .fin

	.menor:
		inc eax						;eax = 0 + 1 = 1 caso a<b 
	
	.fin:
		;desarmo el stack frame
		add rsp, 8
		pop rbx		
		pop rbp

		ret
	
; char* str_concat(char* a, char* b)
;En RDI = a , RSI= b
str_concat:
	;armo el stack frame
	push rbp
	mov rbp, rsi
	push rbx		;voy a hacer un call entonces necesito dos registros para guardar los valores en rdi y rsi
	push r12
	push r13		;necesito un registro para guardar la longitud de 'a'		
	push r14		;aca guardo la long de 'b' y le sumo la de 'a'

	cmp rdi, NULL	;veo si hay algo en a, si los dos fueran null igual esta bien devolver uno de los dos
	je .solo_b
	cmp byte[rdi], NULL	;formatVacio: db "", 0 ---> si el primer elemento es NULL esta solo el delimitador 
	je .solo_b
	cmp rsi, NULL
	je .solo_a		;veo si hay algo en b
	cmp byte[rsi], NULL
	je .solo_a

	;RBX = a, R12 = b
	mov rbx, rdi	
	mov r12, rsi	
	
	call str_len	;en rdi estaba a, obtengo su longitud
	mov r13d, eax	;en r13d pongo la longitud de a, la voy a necesitar despues en copy tambien
	dec r13d		;lo decremento en 1 no quiero considerar el delimitador de a
	mov rdi, r12	;ahora en rdi pongo b	
	call str_len
	mov	r14d, eax	;guardo la longitud de 'b'
	add r14d, r13d	;sumo la longitud de 'a' a la de 'b' 	
	xor rdi, rdi	;seteo en 0 rdi	
	mov edi, r14d	
	call malloc		;en rax esta la nueva posicion de memoria para los dos char, esto es o que devuelvo como resultado
	
	;Ahora tengo que copiar 'a' en la primera parte de la posicion de memoria y a 'b' en la segunda sin el delimitador de a	
	mov r14, rax	;ya no necesito los valores en r14 y puedo reutlizar el registro
	xor rcx, rcx
	mov ecx, r13d	;en el contador pongo la longitud de 'a' sin el delimitador, ya puedo reutilizar el registro r13
	
	xor r13, r13
	.ciclo_a:
		mov r13b, [rbx]		;uso a r13 de registro intermedio		
		mov [r14], r13b
		inc r14				;me muevo un byte hacia adelante en la memoria
		inc rbx				;me muevo un byte hacia adelante recorriendo 'a'
		loop .ciclo_a

	.ciclo_b:
		mov r13b, [r12]
		mov byte[r14], r13b	
		cmp byte[r12], NULL
		je .fin
		inc r14		
		inc r12				;me muevo un byte hacia adelante recorriendo 'b'
		jmp .ciclo_b
	
	.solo_a:
		mov rax, rdi
		jmp .fin

	.solo_b:
		mov rax, rsi	

	.fin:					;en rax ya esta el valor de retorno
	;desarmo el stack frame
	pop r14
	pop r13
	pop r12
	pop rbx	
	pop rbp
	
	ret
	
;########### Funciones: Matriz

; matrix_t* matrixNew(uint32_t m, uint32_t n);
;En EDI = m, ESI = n
matrixNew:
	;armo el stack frame
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8

	;En EBX = m,   R12d = n	
	mov ebx, edi
	mov r12d, esi

	;pido memoria para la nueva matriz
	mov rdi, SIZE_MATRIZ
	call malloc
	;en rax esta el puntero al pedazo de memoria que pedi, esto es lo que devuelve la funcion
	mov dword[rax+offset_type], MATRIX
	mov qword[rax+offset_remove], matrixDelete
	mov qword[rax+offset_print], matrixPrint
	mov dword[rax+offset_m], ebx			;m = filas
	mov dword[rax+offset_n], r12d			;n = columnas
	mov qword[rax+offset_datoM], NULL	;esto lo hago provisoriamente luego pondre los valores 
	
	mov r15, rax		;guardo la dir de memo donde comienza el struct matriz

	;En RBXd = m,   R12d = n
	mov eax, ebx	;el multiplicador tiene que estar en eax
	mul r12d		;multiplico n por m, el resultado aparece en EDX EAX  parte alta y baja
	
	;el resultado esta en EDX EAX
	mov eax, eax		;limpia la parte alta de RAX
	shl rdx, DWORD		;limpia la parte baja shifteando a la izquierda 32 bits
	or rax, rdx			;quedan ambas partes en rax (n*m)
	
	mov r14, rax		;preservo este valor para ponerlo despues en el contador	
	

	shl rax, TRES		;shifteo tres veces a la izquierda para multiplicar por 8 = 2^3, cada shift es como multiplicar por 2 (n*m*8)
	
	mov rdi, rax
	call malloc		;en rax esta la dir de memo donde empieza la matriz
	
	mov qword[r15+offset_datoM], rax

	xor rcx, rcx
	mov rcx, r14		;genero un contador con el valor n*m para rellenar la matriz de NULL
	
	.cicloRellenarMatriz:
		mov qword[rax], NULL
		lea rax, [rax + 8]
		loop .cicloRellenarMatriz
	
	mov rax, r15	

	;desarmo el stack frame
	add rsp, 8
	pop r15
	pop r14	
	pop r13	
	pop r12
	pop rbx	
	pop rbp
	

ret



; matrix_t* matrixAdd(matrix_t* m, uint32_t x, uint32_t y, void* data);
;En RDI = m, ESI = x, EDX = y, RCX = data 
matrixAdd:
	;armo el stack frame
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8

	;En R12d = y , R13 = m, R15 = *data
	mov r12d, edx	;preservo el valor de y necesito a rdx para la multiplicacion
	mov r13, rdi
	mov r15, rcx

	;Para ubicar la dir de memo de la matriz donde tengo que poner data hay que hacer la siguiente cuenta:
	; punteroAMatriz + 8(y*m+x) 
	; m que es la cantidad de columnas la obtengo de la estructura de la matriz

	mov ebx, [rdi+offset_m]  	;en ebx esta el valor de m
	mov eax, r12d				;pongo y en el multiplicador	
	mul ebx 					;el resultado aparece en EDX EAX parte alta y baja
	
	;considero que el resultado esta en EAX de lo contrario la matriz superaria la cantidad de memo disponible, en EDX hay ceros

	add eax, esi    				;sumo el valor de x
	mov eax, eax					;limpio la parte alta de rax	
	shl rax, TRES					;shifteo a izquierda 3 veces = multiplicar por 8 = 2 ^ 3

	add rax, [rdi+offset_datoM]		;sumo la dir de la matriz, que es de 8bytes
	mov r14, rax					;preservo la posicion de la matriz para despues del call
	cmp qword[rax], NULL	
	je .nuevoDato
	mov rdi, [rax]					;pongo el puntero al struct como parametro
	mov rbx, [rdi+offset_remove]	;cargo el programa delete en rbx	
	call rbx						;elimino el dato que estaba en esa posicion de la matriz

	.nuevoDato:
		mov [r14], r15					;pongo data en la posicion de memoria eax

	.fin:	
		mov rax, r13					;devuelvo el puntero al struct matriz   

	;desarmo el stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	
	ret
	
; matrix_t* matrixRemove(matrix_t* m, uint32_t x, uint32_t y);
;En RDI = m, ESI = x, EDX = y	
matrixRemove:
	;armo el stack frame 
	push rbp
	mov rbp, rsp		;PILA ALINEADA
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8 

	;En En R12d = y, R15 = m 
	mov r12d, edx	;preservo el valor de y necesito a rdx para la multiplicacion
	mov r15, rdi	;preservo el valor del puntero a matriz porque voy a hacer un call

	;Para ubicar la dir de memo de la matriz donde tengo que borrar data hay que hacer la siguiente cuenta:
	; punteroAMatriz + 8(y*m+x) 
	; m que es la cantidad de columnas la obtengo de la estructura de la matriz

	mov ebx, [rdi+offset_m]  	;en r12 esta el valor de m
	mov eax, r12d				;pongo y en el multiplicador	
	mul ebx 					;el resultado aparece en EDX EAX parte alta y baja
	
	;considero que el resultado esta en EAX de lo contrario la matriz superaria la cantidad de memo disponible, en EDX hay ceros

	add eax, esi    				;sumo el valor de x
	mov eax, eax					;limpio la parte alta de rax	
	shl rax, TRES					;shifteo a izquierda 3 veces = multiplicar por 8 = 2 ^ 3
	add rax, [rdi+offset_datoM]		;sumo la dir de la matriz, que es de 8bytes
	
	;en rax esta la dir de la matriz a borrar
	
	cmp qword[rax], NULL			;si no hay nada en esa posicion de la matriz termino
	je .fin
	
	mov r13, [rax]					;ahora estoy en el struct del dato, r13 la dir al struct dato
	mov qword[rax], NULL			;En la posicion de la matriz lo pongo a NULL el puntero
	mov rax, r13					 
	lea rax, [rax+offset_remove]	
	mov r14, [rax]					;en r14 esta la dir del programa delete
	mov rdi, r13					;pongo en rdi el puntero a struct dato, es el parametro que necesito para hacer el call
	call r14						;elimino el struct dato apuntado
	

	.fin:
	mov rax, r15					;devuelvo el puntero al struct matriz

	;desarmo el stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp		

	ret
	
;void matrixDelete(matrix_t* m);
;En RDI = m
matrixDelete:
	;armo el stack frame
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14	

	;En RBX = m   lo preservo voy a hacer varios call
	mov rbx, rdi
	
	xor r13, r13						;r13 es x, inicilamente en cero
	xor r14, r14						;r14 es y, inicialmente en cero	


	;Preparo parametros para llamar a la funcion remove del struct Matriz  RDI = *m , ESI = x, EDX = y
	;en rdi	ya esta el puntero al struct matriz 	
	mov esi, r13d						;seteo esi, donde va a estar x 
	mov edx, r14d						;seteo edx, donde va a estar y  	  	
	
	

	.cicloBorrado:						;borro todo el contenido en la matriz
		call matrixRemove
		inc r13							;aumento en 1 a x	
		cmp r13d, [rbx+offset_m]		;si llegue al tope reseteo el valor de x y paso a la otra fila		
		je .resetear
		mov rdi, rbx					;preparo los registros con los parametros para el proximo call
		mov esi, r13d
		mov edx, r14d
		jmp .cicloBorrado		

	.resetear:
		xor r13, r13
		inc r14							;cambio de fila
		cmp r14d, [rbx+offset_n]		;llegue al tope no hay mas filas
		je .finCiclo
		mov rdi, rbx					;preparo los registros con los parametros para el proximo call					
		mov esi, r13d
		mov edx, r14d							 			
		jmp .cicloBorrado 	
		
	.finCiclo:
		mov rdi, [rbx+offset_datoM]		;obtengo la dir de la matriz
		call free						;elimino la matriz de datos que ahora todas sus posiciones apuntan a NULL
		mov rdi, rbx					;elimino el struct matriz
		call free

	;desarmo el stack frame
	pop r14
	pop r13	
	pop r12
	pop rbx
	pop rbp
	
	ret


;void matrixPrint(matrix_t* m, FILE *pFile)
;En RDI = m , RSI = pFile
matrixPrint:
	;armo el stack frame
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8

	;En RBX = m , R12 = pFile		;preservo los registros porque voy a hacer calls
	mov rbx, rdi
	mov r12, rsi

	
	mov r13, [rbx+offset_datoM]			;en R13 posicion de memoria donde inicia la matriz
	
	;obtengo n*m*8 y luego le sumo la dir de inicio de la matriz para saber la posicion de memoria donde termina la matriz 	
	
	mov r14d, [rbx+offset_n]
	mov eax, [rbx+offset_m]		;el multiplicador tiene que estar en eax
	mul r14d					;multiplico n por m, el resultado aparece en EDX EAX parte alta y baja
	
	;el resultado esta en EDX EAX
	mov eax, eax		;limpia la parte alta de RAX
	shl rdx, DWORD		;limpia la parte baja shifteando a la izquierda 32 bits
	or rax, rdx			;quedan ambas partes en rax (n*m)
	shl rax, TRES		;shifteo tres veces a la izquierda para multiplicar por 8 = 2^3, cada shift es como multiplicar por 2 (n*m*8)

	add rax, r13		;le sumo, el valor de memoria donde inicia la matriz	
	mov r14, rax 		;obtengo en r14 la posicion de memoria donde finaliza la matriz
	
	xor r15, r15		;en r15 voy a contar la cantidad de veces que imprimo un elemento de la matriz, para saber cuando termina la fila

	.cicloDeImpresion:					;imprimo todo el contenido en la matriz
		mov rdi, r12			
		mov rsi, formatM1
		call fprintf					;imprimo la barra		
		
		mov rsi, [r13] 					;cargo en rsi el puntero a la estructura a la que apunta 
		cmp rsi, NULL
		je .imprimirNULL		
			
		mov rdi, r12					;cargo en rdi el puntero a pFIle
		mov rcx, [rsi+offset_print]		;en rcx cargo el programa de impresion de la estructura apuntada por esa posicion de la matriz 
		call rcx

		mov rdi, r12			
		mov rsi, formatM1
		call fprintf					;imprimo la barra de cierre

		add r13, OCHO					;aumento la posicion de memoria en 8 bytes
		cmp r13, r14					;veo si llegue a la posicion final
		je .fin	
		 
		inc r15
		cmp r15d, [rbx+offset_m]		;veo si llegue al final de la fila							
		je .imprimirSalto

		jmp .cicloDeImpresion	
				

	.imprimirNULL:
		mov rdi, r12			
		mov rsi, formatM3
		call fprintf

		mov rdi, r12			
		mov rsi, formatM1
		call fprintf					;imprimo la barra de cierre

		add r13, OCHO					;aumento la posicion de memoria en 8 bytes
		cmp r13, r14					;veo si llegue a la posicion final
		je .fin	
		 
		inc r15
		cmp r15d, [rbx+offset_m]		;veo si llegue al final de la fila							
		je .imprimirSalto

		jmp .cicloDeImpresion	
	
	.imprimirSalto:
		mov rdi, r12
		mov rsi, formatM2
		call fprintf					;imprimi la coma

		xor r15, r15					;reseteo el contador de cantidad de elementos de la fila
		jmp .cicloDeImpresion

		
	.fin:	

	;desarmo el stack frame
	add rsp, 8
	pop r15	
	pop r14
	pop r13	
	pop r12		
	pop rbx
	pop rbp
	
	ret

	
;########### Funciones: Lista

;list_t* listNew();
listNew:
	;armo el stack frame
	push rbp
	mov rbp, rsp

	;pido memoria para la nueva lista
	mov rdi, SIZE_LISTA
	call malloc
	;en rax esta el puntero al pedazo de memoria que pedi, esto es lo que devuelve la funcion
	mov dword[rax+offset_type], LIST
	mov qword[rax+offset_remove], listDelete
	mov qword[rax+offset_print], listPrint
	mov qword[rax+offset_prim], NULL

	;desarmo el stack frame
	pop rbp

	ret
	
; list_t* listAddFirst(list_t* l, void* data);
;En RDI = l, RSI = data 
listAddFirst:
	;armo el stack frame
	push rbp
	mov rbp, rsp
	push rbx		;voy a hacer un call para reservar memoria necesito resguardar los parametros que llegan a la funcion
	push r12
	push r13		;lo necesito de registro auxiliar, para no hacer mov de memo a memo
	sub rsp, 8		;alineo la pila a 16bytes

	;En RBX = l, R12 = data	
	mov rbx, rdi
	mov r12, rsi

	;pido memoria para el nuevo nodo
	mov rdi, SIZE_NODO
	call malloc
	mov qword[rax+offset_data], r12		;pongo a data en su lugar en el nodo
	
	cmp qword[rbx + offset_prim], NULL		;veo si la lista tiene o no algun nodo primero
	je .listaVacia
	mov r13, [rbx + offset_prim]		;en este caso la lista tiene un primero
	mov qword[rax+offset_prox], r13		;pongo al primero de la lista como proximo del nodo recien creado
	mov qword[rbx+offset_prim], rax		;como primero pongo ahora la direccion del nodo recien creado
	jmp .fin		
	
	.listaVacia:
		mov qword[rax+offset_prox], NULL		;agrego un nodo que no tiene proximo
		mov qword[rbx+offset_prim], rax			;pongo la direccion del nuevo nodo en *prim  			
		
	.fin:
		mov rax, rbx		;la funcion devuleve el puntero a la lista que recibe como parametro

	
	;desarmo el stack frame 
	add rsp, 8	
	pop r13	
	pop r12
	pop rbx
	pop rbp	

	ret
	
; list_t* listAddLast(list_t* l, void* data);
;En RDI = l, RSI = data 
listAddLast:
	;armo el stack frame
	push rbp
	mov rbp, rsp
	push rbx		;necesito dos registros para resguardar los parametros, voy a hacer un call para reservar memoria 
	push r12
	push r13
	push r14	

	;En RBX = l, R12 = data 	
	mov rbx, rdi
	mov r12, rsi	
	;pido memoria para un nuevo nodo	
	mov rdi, SIZE_NODO 	
	call malloc
	mov qword[rax+offset_data], r12	
	mov qword[rax+offset_prox], NULL	;ya quedo armado el ultimo nodo cuya direccion de memoria esta en rax
	
	lea r13, [rbx+offset_prim]	;en r13 esta la direccion donde se guarda el puntero a prim
	mov r14, [r13]				;pongo en r14 lo que hay guardado en la direccion r13, o sea la dir del primer nodo
	cmp r14, NULL				;si apunta a null, no hay nodos, lo agrego como primero
	je .agregarNodoPrim
			
		
	.ciclo:						;hago un ciclo para recorrer toda la lista hasta llegar al ultimo nodo 
		cmp qword[r14+offset_prox], NULL		;me fijo si el nodo tiene proximo
		je .agregarUltimo
		mov r13, [r14+offset_prox]	;le asigno a r13 la posicion de memoria del proximo nodo
		mov r14, r13				;pongo este valor en r14, ahora estoy apuntando al nuevo nodo y comienzo de nuevo el ciclo
		jmp .ciclo 

	.agregarUltimo:
				
		mov qword[r14+offset_prox], rax		
		jmp .fin	

	.agregarNodoPrim:
		mov [r13], rax 

	.fin:
		mov rax, rbx
	;desarmo el stack frame
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	
	ret
	
; list_t* listAdd(list_t* l, void* data, funcCmp_t* f);		
;En RDI = l, RSI = data, RDX = f 
listAdd:
	;armo el stack frame
	push rbp
	mov rbp, rsp	;PILA ALINEADA
	sub rsp, 8	
	push rbx
	push r12
	push r13
	push r14
	push r15
	

	;En RBX = l, R12=data, R13=f
	mov rbx, rdi
	mov r12, rsi
	mov r13, rdx

	;creo un nodo que por el momento su proximo va a apuntar a NULL hasta que vea donde estara ubicado en la lista
	mov rdi, SIZE_NODO
	call malloc			;en rax esta la posicion de memo del nodo a insertar
	mov qword[rax+offset_data], r12
	mov qword[rax+offset_prox], NULL
	mov qword[rbp-8], rax  

	;veo si prim apunta a Null si es asi lo agrego ahi el nodo
	cmp qword[rbx+offset_prim], NULL
	je .agregarPrim

	;sino tengo que ver segun el comparador donde lo inserto, mientras sea >= avanzo
	mov r14, [rbx+offset_prim]		;en r14 tengo la dir del proximo nodo
	lea r15, [rbx+offset_prim]		;en r15 voy a guardar la posicion de memo del nodo anterior que contiene la dir del prox 	
	

	
	.ciclo:
		mov rdi, r12					;pongo en rdi puntero del dato que llega como parametro, lo hago todas las veces, despues del 										;call podria cambiar el valor 			
		mov rsi, [r14+offset_data]			;pongo el puntero al dato del nodo actual
		call r13							;llamo a la funcion comparar
		cmp eax, UNO						;si me devuelve 1 la funcion de comparacion entonces a<b 
		je .insertar						;si da igual es porque: b > a me pase, lo tengo que insertar antes al nodo
		cmp qword[r14+offset_prox], NULL	;si el nodo no contiene un siguiente llegue al ultimo, inserto como ultimo al nodo
		je .agregarUltimo
		lea r15, [r14+offset_prox]
		mov r14, [r15]
		jmp .ciclo


	.insertar:
		mov rax, [rbp-8]						
		mov qword[rax+offset_prox], r14				;pongo a prox del nodo a insertar, al nodo actual
		mov qword[r15], rax					;pongo el nuevo nodo como prox del anterior al nodo actual 		
		jmp .fin		

	.agregarUltimo:
		mov rax, [rbp-8]
		mov qword[r14+offset_prox], rax
		jmp .fin

	.agregarPrim:
		mov rax, [rbp-8]
		mov qword[rbx+offset_prim], rax
		
	.fin:
		mov rax, rbx		;la funcion devuelve el puntero a la lista

	;desarmo el stack frame
	
	pop r15	
	pop r14
	pop r13
	pop r12
	pop rbx
	add rsp, 8
	pop rbp	
	
	ret
	
; list_t* listRemove(list_t* l, void* data, funcCmp_t* f);
;En RDI = l, RSI = data, RDX = f 
listRemove:
	;armo el stack frame
	push rbp
	mov rbp, rsp	;PILA ALINEADA
	push rbx
	push r12
	push r13
	push r14			;en este registro guardo la dir de memo del nodo actual
	push r15
	sub rsp, 8

	;En RBX = l, R12=data, R13=f
	mov rbx, rdi
	mov r12, rsi
	mov r13, rdx


	
	cmp qword[rbx+offset_prim], NULL		;no hay lo que borrar
	je .fin
	lea r15, [rbx+offset_prim]		;r15 dir de memo del nodo anterior donde guarda puntero a dir de actual	
	mov r14, [r15]					;r14 dir del nodo actual

	
	.ciclo:
		mov rdi, r12
		mov rsi, [r14+offset_data]
		call r13
		cmp eax, NULL				;comparo el valor de retorno con 0, eso implica a = b
		je .borrar
		cmp qword[r14+offset_prox], NULL	;veo si el nodo actual tiene proximo
		je .fin						;si no, voy al fin 
		lea r15, [r14+offset_prox]	;si hay un proximo avanzo un nodo hacia adelante
		mov r14, [r15]
		jmp .ciclo

	.borrar:   
		mov rcx, [r14+offset_prox] 			;uso el registro rcx como variable intermedia
		mov qword[r15], rcx					;en el anterior pongo la dir del proximo al actual
		mov rcx, [r14+offset_data]			;tengo la dir del struct
		mov rax, [rcx + offset_remove]		;pongo en rax la dir del programa remover en el struct
		mov rdi, rcx						;cargo en rdi el parametro para llamar a la funcion remover
		call rax							;remuevo los datos apuntados por el struct data
		mov rdi, r14						;borro el nodo en si
		call free
		mov r14, [r15]						;el nuevo nodo actual es el siguiente
		cmp r14, NULL
		je .fin								;si el nodo siguiente es NULL termine
		jmp .ciclo							;sino sigo iterando para seguir borrando

	.fin:
	mov rax, rbx					;la funcion devuelve un puntero a la lista

	;desarmo el stack frame
	add rsp, 8
	pop r15	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp	
	
	ret
	
; list_t* listRemoveFirst(list_t* l);
;En RDI = l
listRemoveFirst:
	;armo el stack frame
	push rbp		;PILA ALINEADA
	mov rbp, rsp
	push rbx		;voy a hacer un call para liberar memo preservo l
	push r12
	push r13
	push r14	

	;En RBX = l		
	mov rbx, rdi

	cmp qword[rbx+offset_prim], NULL		;si no hay primer nodo no hay lo que remover, salta al fin
	je .fin	

	mov r12, [rbx+offset_prim]	;puntero al primer nodo
	mov r13, [r12+offset_prox]	;obtengo del primer nodo el puntero al proximo, en r13 queda la dir del nuevo primero
	mov r14, [r12+offset_data]	;en r14 esta la direccion del struct data al que apunto
	mov rax, [r14+offset_remove] ;en rdi pongo la direccion del programa para borrar los datos apuntados por el struct data		
	mov rdi, r14				;en rdi paso el parametro de la direccion del struct 	
	call rax					;llamo a la funcion remover
	mov rdi, [rbx+offset_prim]	;ahora elimino el nodo en si 
	call free
	mov qword[rbx+offset_prim], r13	;ahora el primero de la lista es el proximo del que elimine

	.fin:
		mov rax, rbx			; la funcion devuelve el puntero a la lista pasado como parametro 

	;desarmo el stack frame
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp	
	
	ret
	
; list_t* listRemoveLast(list_t* l);
;En RDI = l
listRemoveLast:
	;armo el stack frame
	push rbp
	mov rbp, rsp	;PILA ALINEADA 
	push rbx
	push r12
	push r13
	push r14

	;En RBX = l
	mov rbx, rdi		;lo preservo voy a hacer varios call

	mov r12, [rbx+offset_prim]
	cmp r12, NULL				;si no hay ningun nodo, no hay lo que borrar
	je .fin	
	lea r13, [rbx+offset_prim]

	.ciclo:		
		cmp qword[r12+offset_prox], NULL			;si el nodo no tiene proximo es el nodo que quiero borrar
		je .borrar
		lea r13, [r12+offset_prox]		;En r13 me guardo la direccion del nodo anterior en el lugar donde va el puntero a prox
		mov r12, [r13]					;en r12 esta ahora la direccion del proximo nodo, o Null si no lo hubiera, nodo actual.
		jmp .ciclo

	.borrar:
		mov r14, [r12+offset_data]		;aca tengo la dir del struct data
		mov rax, [r14+offset_remove]	;en rax pongo la dir del programa para remover los datos apuntados por el struct data	
		mov rdi, r14					;paso como parametro la direccion del struct data 		
		call rax						;llamo a la funcion delete del dato
		mov rdi, r12					;elimino el nodo
		call free
		mov qword[r13], NULL			;Ahora el anteultimo nodo es el ultimo 

	.fin:
		mov rax, rbx			;devuelvo el puntero a la lista  	
		
	;desarmo el stack frame
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	
	ret
	
; void listDelete(list_t* l);
;En RDI=l
listDelete:
	;armo el stack frame
	push rbp
	mov rbp, rsp
	push rbx
	sub rsp, 8
	

	;en RBX = l	
	mov rbx, rdi

	
	
	.ciclo:
		cmp qword[rbx+offset_prim], NULL		;termine de borrar todos los nodos
		je .eliminarLista
		mov rdi, rbx					;cargo en rdi el puntero a la lista y llamo a la funcion remove almacenada
		call listRemoveFirst
		jmp .ciclo						;continuo hasta eliminar todos los nodos


	.eliminarLista:						;finalmente elimino la lista
		mov rdi, rbx
		call free

	;desarmo el stack frame

	add	rsp,8
	pop rbx
	pop rbp

	
	ret
	


; void listPrint(list_t* m, FILE *pFile);
;En RDI = m , RSI = pFile
listPrint:
	;armo el stack frame 
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14

	;En RBX = m, R12 = pFile
	mov rbx, rdi
	mov r12, rsi

	mov rdi, r12
	mov rsi, format1	;imprimo el corchete de apertura
	call fprintf
 	
	cmp qword[rbx+offset_prim], NULL	; si la lista esta vacia solo imprime los corchetes de apertura y cierre
	je .fin
	
	mov r13, [rbx+offset_prim]		;en r13 esta la direccion del nodo actual
	mov r14, [r13+offset_data]		;en r14 la dir del struct de data del nodo actual
	mov rdi, r14					;paso los parametros para llamar a la funcion print 
	mov rsi, r12					; en RDI = dir struct dato , RSI = pfile
	mov rax, [r14+offset_print]		;ahora pongo en rax la dir del programa de impresion
	call rax						;imprimo el dato

	.ciclo:
		cmp qword[r13+offset_prox], NULL		;veo si hay un nodo proximo
		je .fin
		mov rdi, r12
		mov rsi, format2
		call fprintf							;imprimo la coma
		lea r14, [r13+offset_prox]				;me guardo la dir de la posicion del nodo donde esta el puntero a proximo  
		mov r13, [r14]							;en r13 tengo la dir del nodo actual
		mov r14, [r13+offset_data]				;en r14 la dir del struct
		mov rax, [r14+offset_print]				;en rcx la dir del programa de impresion
		mov rdi, r14							;en rdi paso el parametro 1: el puntero a la estructura
		mov rsi, r12							;en rsi paso el parametro 2: el puntero pFile
		call rax								;llamo a la funcion	
		jmp .ciclo
			

	.fin:
		mov rdi, r12
		mov rsi, format3	;imprimo el corchete de cierre
		call fprintf

	;desarmo el stack
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp	

	ret
	
;########### Funciones: String

; string_t* strNew();
strNew:
	;armo el stack frame
	push rbp
	mov rbp, rsp	;PILA ALINEADA porque cuando se llama a strNew se guarda en el stack la dir de retorno del programa en ejecucion
	
	;pido memoria para el string
	mov rdi, SIZE_STRING
	call malloc
	;en rax esta el puntero al pedazo de memoria que pedi, esto es lo que devuelve la funcion
	mov dword[rax+offset_type], STRING
	mov qword[rax+offset_remove], strDelete
	mov qword[rax+offset_print], strPrint
	mov qword[rax+offset_dato], NULL
	
	;desarmo el stack frame
	pop rbp
	ret
	
; string_t* strSet(string_t* s, char* c);
;En RDI= s, RSI=c
strSet:
	;armo el stack frame
	push rbp
	mov rbp, rsp	;PILA ALINEADA
	push rbx
	push r12
	push r13
	sub rsp, 8

	mov rbx, rdi	;preservo parametros de entrada
	mov r12, rsi	

	mov rdi, r12	;pongo en rdi el puntero c, para llamar a la funcion str_copy	
	call str_copy	;obtengo en rax la posicion de memoria donde esta la copia	
	mov r13, rax	;preservo la dir de memo del nuevo string

	cmp qword[rbx+offset_dato], NULL
	je .agregarDato
	
	mov rdi, rbx	
	call strRemove

	.agregarDato:
		mov qword[rbx+offset_dato], r13		;pongo el puntero de la nueva direccion de memoria donde esta la copia del string		
		mov rax, rbx	 					;devuelvo en rax el puntero a la estructura string_t
	

		
	;desarmo el stack frame
	add rsp, 8	
	pop r13
	pop r12
	pop rbx	
	pop rbp
	ret
	

	
; string_t* strAddRight(string_t* s, string_t* d);
;En RDI = s, RSI=d 
strAddRight:
	;armo el stack frame
	push rbp
	mov rbp, rsp  ;PILA ALINEADA
	push rbx
	push r12
	push r13
	push r14

	;EN RBX = s, R12 = d
	mov rbx, rdi			;preservo los valores de punteros recibidos como parametro
	mov r12, rsi
	
	mov rdi, [rbx+offset_dato] 	;pongo en rdi el char* de s
	mov rsi, [r12+offset_dato]	;en rsi pongo el char* de d
	call str_concat				;llamo a la funcion para concatenar estos dos strings queda s+d, en rax tengo el nuevo puntero a memo 
	mov r13, rax				;guardo la posicion de memo de s+d
	cmp rbx, r12				;veo si los dos punteros string_t* son el mismo
	je .sonElMismo
	mov rdi, r12
	call strDelete				;Elimino la string d en su totalidad
	

	.sonElMismo:
		mov rdi, rbx
		call strRemove					;Borro el dato contenido en s y lo reemplazo por s+d, En rax ya queda la posicion de memo de s
		mov qword[rbx+offset_dato], r13		
		         						
	mov rax, rbx
	;desarmo el stack frame
	pop r14
	pop r13	
	pop r12
	pop rbx	
	pop rbp	

	ret
	
; string_t* strAddLeft(string_t* s, string_t* d);
;En RDI = s, RSI=d 
strAddLeft:
	;armo el stack frame
	push rbp
	mov rbp, rsp  ;PILA ALINEADA
	push rbx
	push r12
	push r13
	push r14

	;EN RBX = s, R12 = d
	mov rbx, rdi			;preservo los valores de punteros recibidos como parametro
	mov r12, rsi
	
	;los argumentos entran al reves que en el caso anterior y por lo tanto concatena d+s
	mov rdi, [r12+offset_dato]	;en rsi pongo el char* de d
	mov rsi, [rbx+offset_dato] 	;pongo en rdi el char* de s
	call str_concat				;llamo a la funcion para concatenar estos dos strings queda s+d, en rax tengo el nuevo puntero a memo 
	mov r13, rax				;guardo la posicion de memo de d+s
	cmp rbx, r12				;veo si los dos punteros string_t* son el mismo
	je .sonElMismo
	mov rdi, r12
	call strDelete				;Elimino la string d en su totalidad

	.sonElMismo:
		mov rdi, rbx					
		;ACA PODRIA LLAMAR A LA FUNCION CONTENIDA EN LA ESTRUCTURA MEDIANTE EL PUNTERO REMOVE
		call strRemove					;Borro el dato contenido en s y lo reemplazo por s+d, En rax ya queda la posicion de memo de s
		mov qword[rbx+offset_dato], r13	;cargo d+s en la string s	
		         						
		
	;desarmo el stack frame
	pop r14
	pop r13	
	pop r12
	pop rbx	
	pop rbp	

	ret
	
	
; string_t* strRemove(string_t* s);
;En RDI = s
strRemove:
	;armo el stack frame
	push rbp
	mov rbp, rsp   ;PILA ALINEADA	

	cmp qword[rdi+offset_dato], NULL
	je .res						;No apuntaba a ningun dato
								;Sino, habia un dato, entonces lo remuevo

	.remove:
		push rbx
		sub rsp, 8							;alineo la pila a 16bytes
		
		mov rbx, rdi						;preservo en rbx lo que hay en rdi antes del call
		mov rdi, [rbx+offset_dato]
		call free							;libero la porcion de memoria donde esta el dato apuntado por rdi = i
		mov qword [rbx+offset_dato], NULL	;le asigno a la posicion de memoria donde esta el puntero a dato el valor 0 = NULL
		mov rax, rbx						;pongo en rax el valor que llega por parametro, es el mismo que devuelve la funcion
		
		add rsp, 8
		pop rbx	
		jmp .fin							

	.res:
		mov rax, rdi						;Pongo en rax el valor de retorno que es el puntero i que esta en rdi		
	
	.fin:
	;desarmo el stack frame
	pop rbp
	ret
	
; void strDelete(string_t* s);
strDelete:
;armo el stack frame
	push rbp
	mov rbp, rsp   ;PILA ALINEADA
	
	;SI NO COMPILA ESTA FUNCION PUEDE SER POR COMO ESCRIBI EL LLAMADO								
		;llamo a la funcion intRemove, en rdi ya esta el puntero que necesito como parametro
	call strRemove						;si esto no funciona hacer: lea rax, [rdi+offset_remove] y luego call rax 
	mov rdi, rax					;me aseguro despues del call de volver a poner en rdi, el valor del puntero devuelto en rax para llamar al 										;call free 
	call free      					;ya esta en rdi la posicion de memoria, a partir de la cual quiero liberar la memoria 				  
	
	;desarmo el stack frame
	pop rbp
	
	ret								;es una funcion void no retorna nada en eax

	
; int32_t strCmp(string_t* a, string_t* b);
;En RDI = a, RSI = b
strCmp:
	;armo el stack frame
	push rbp
	mov rbp, rsp   	;PILA ALINEADA	
	push rbx		;Voy a hacer un call necesito dos registros para preservar a y b	
	push r12
	
	;En RBX = a, R12 = b
	mov rbx, rdi
	mov r12, rsi
	
	mov rdi, [rbx + offset_dato]
	mov rsi, [r12 + offset_dato]
	call str_cmp					;En rax esta el valor solicitado		

	;desarmo el stack frame
	pop r12
	pop rbx	
	pop rbp
	
	ret


;void strPrint(string_t* m, FILE *pFile);
strPrint:
;armo el stack frame
	push rbp
	mov rbp, rsp   		;PILA ALINEADA
	push rbx		; preservo los valores porque los utilizo para guardar los valores que llegan por parametro	
	push r12
	push r13
	sub rsp, 8

	;En RBX = m, RSI = pFile
	mov rbx, rdi
	mov r12, rsi	
	mov r13, [rbx+offset_dato]  ;En r13 guardo el puntero al char 

	cmp r13, NULL
	je .esNull


	mov rdi, r12
	mov rsi, formatStr1
	mov rdx, r13			;le paso la dir donde empieza el string	
	xor rax, rax			
	call fprintf
	jmp .fin

	.esNull:
		mov rdi, r12
		mov rsi, formatStr2	;imprimo NULL	
		call fprintf			

	.fin:
	;desarmo el stack frame
	add rsp, 8
	pop r13	
	pop r12
	pop rbx
	pop rbp
	ret
	
;########### Funciones: Entero



; integer_t* intNew();    FALTA DEFINIR LOS OFFSET PARA LA ESTRUCTURA ENTERO
intNew:
	;armo el stack frame
	push rbp	;PILA ALINEADA
	mov rbp, rsp

	;pido memoria para el entero
	mov rdi, SIZE_ENTERO
	call malloc
	;en rax esta el puntero al pedazo de memoria que pedi
	mov dword[rax+offset_type], INTEGER			;indico que de los tipos posibles, es un ENTERO, en enum tiene asignado el valor 1
	mov qword[rax+offset_remove], intDelete			;ahi pongo el programa intRemove
	mov qword[rax+offset_print], intPrint			;ahi pongo el programa intPrint
	mov qword[rax+offset_dato], NULL			;seteo el puntero al dato en 0
	
	;deshago el stack frame
	pop rbp										;lo que estoy apuntando con rsp en la pila lo pone en rbp
	ret
	
; integer_t* intSet(integer_t* i, int d);
; En RDI = i , ESI = d   porque d es un entero ocupa solo 32 bits y por eso estara en ESI no en RSI 

intSet:
	;armo el stack frame
	push rbp
	mov rbp, rsp   		;PILA ALINEADA
	push rbx			;Desalinea la pila, necesito este registro para preservar el valor que esta en rdi porque voy a utilizar este 							;registro para llamar a malloc y free
	push r12			;para preservar esi antes del llamado	
	
	;RBX = i, R12d = d
	mov rbx, rdi
	mov r12d, esi

	cmp qword[rbx+offset_dato], NULL 
	jne .modificarDato
	
	.agregarDato:	 
		mov rdi, INT_SIZE   				;cargo en rdi la cantidad de espacio de memoria que quiero reservar para poner el dato 'd'		
		call malloc							;en rax esta la posicion de memoria donde comienza el espacio reservado
		mov dword[rax], r12d				;pongo el dato en esa posicion de memoria
		mov qword[rbx+offset_dato], rax  	;Pongo el valor de la posicion de memoria de 'd' en la posicion del puntero a dato de integer_t		
		jmp .fin					
	
	.modificarDato:
		
		mov rdi, [rbx+offset_dato]			;pongo en rdi la dir de memo de donde quiero poner el dato
		mov dword[rdi], r12d					;piso el dato que estaba
	
	;desarmo el stack frame
	.fin:
		mov rax, rbx						;Para retornar pongo en rax el puntero i que esta guardado en rbx			
		pop r12	
		pop rbx
		pop rbp
		ret
	
; integer_t* intRemove(integer_t* i);   
;en RDI = i
intRemove:
	;armo el stack frame
	push rbp
	mov rbp, rsp   ;PILA ALINEADA
	
	
	cmp qword[rdi+offset_dato], NULL
	je .res						;No apuntaba a ningun dato
								;Sino, habia un dato, entonces lo remuevo

	.remove:
		push rbx
		sub rsp, 8							;alineo la pila a 16bytes
		
		mov rbx, rdi
		mov rdi, [rbx+offset_dato]			;preservo en rbx lo que hay en rdi antes del call
		call free							;libero la porcion de memoria donde esta el dato apuntado por rdi = i
		mov qword[rbx+offset_dato], NULL	;le asigno a la posicion de memoria donde esta el puntero a dato el valor 0 = NULL
		mov rax, rbx						;pongo en rax el valor que llega por parametro, es el mismo que devuelve la funcion
		
		add rsp, 8
		pop rbx	
		jmp .fin							

	.res:
		mov rax, rdi						;Pongo en rax el valor de retorno que es el puntero i que esta en rdi		
	.fin:
							
		;desarmo el stack frame
		pop rbp
		ret
	
; void intDelete(integer_t* i);   
;En RDI = i
intDelete:
	;armo el stack frame
	push rbp
	mov rbp, rsp   ;PILA ALINEADA
									
	 	
	call intRemove					;llamo a la funcion intRemove, en rdi ya esta el puntero que necesito como parametro
							;si esto no funciona hacer: lea rax, [rdi+offset_remove] y luego call rax 
	mov rdi, rax					;me aseguro despues del call de volver a poner en rdi, el valor del puntero devuelto en rax para llamar al 								;call free 
	call free      					;ya esta en rdi la posicion de memoria, a partir de la cual quiero liberar la memoria 				  
	
	;desarmo el stack frame
	pop rbp
	
	ret								;es una funcion void no retorna nada en eax
	
; int32_t intCmp(integer_t* a, integer_t* b);
;RDI = a, RSI= b
intCmp:
	;armo el stack frame
	push rbp
	mov rbp, rsp   	;PILA ALINEADA
	push rbx		;se desalinea         Necesito dos registros para poder guardar las direcciones de los punteros a los datos de la estructura
	push r12		;se vuelve a alinear

	
	mov rbx, [rdi+offset_dato]	 	;desreferencio lo que hay en el sector de puntero a dato de la estructura para obtener el dato
	mov r12, [rsi+offset_dato]		;indico con d que solo utilizo la parte baja con una longitud de doubleWord 32bits y pone 0 en la parte alta

	mov ebx, [rbx]
	mov r12d, [r12]	
	
	cmp ebx, r12d    				;comparo los datos
	jl .menor
	jg .mayor
	
	.iguales:
		xor eax, eax		;devuelvo 0
		jmp .fin
	
	.menor:
		xor eax, eax
		inc eax				;devuelvo 1
		jmp .fin
	
	.mayor:
		xor eax, eax  		;devuelvo -1
		dec eax

	.fin:
		;desarmo el stack frame
		pop r12
		pop rbx
		pop rbp
		ret
	
; void intPrint(integer_t* m, FILE *pFile);   FALTA HACER
;En RDI = m , RSI = pFile
intPrint:

	;armo el stack frame
	push rbp
	mov rbp, rsp   		;PILA ALINEADA
	push rbx			;preservo los valores porque los utilizo para guardar los valores que llegan por parametro	
	push r12
	push r13
	sub rsp, 8

	;En RBX = m, R12 = pFile
	mov rbx, rdi
	mov r12, rsi	
	mov r13, [rbx+offset_dato]  ;En r13 guardo el puntero al dato 

	cmp r13, NULL
	je .esNull


	mov rdi, r12
	mov rsi, formatInt1
	mov rdx, [r13]			;desreferencio el dato y lo guardo en rdx	
	call fprintf
	jmp .fin

	.esNull:
		mov rdi, r12
		mov rsi, formatInt2	;imprimo NULL
		call fprintf			

	.fin:
	;desarmo el stack frame
	add rsp, 8
	pop r13	
	pop r12
	pop rbx
	pop rbp
	
	
	ret
	
