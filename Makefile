stalloc: main.c lib.o
	gcc -Wall -Wextra main.c build/lib.o -o build/stalloc

lib.o: lib.asm
	@mkdir -p build/
	fasm lib.asm build/lib.o

clean:
	rm -rf build/
