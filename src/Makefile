CC=c99
CFLAGS= -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: main tester

main: main.c matriz_lista_string_c.o matriz_lista_string_asm.o
	$(CC) $(CFLAGS) $^ -o $@

tester: tester.c matriz_lista_string_c.o matriz_lista_string_asm.o
	$(CC) $(CFLAGS) $^ -o $@

matriz_lista_string_c.o: matriz_lista_string.c
	$(CC) $(CFLAGS) -c $< -o $@

matriz_lista_string_asm.o: matriz_lista_string.asm
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f *.o
	rm -f main tester
	rm -f salida.caso.*

