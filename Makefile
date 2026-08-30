stalloc: lib.o
	ld build/lib.o -o build/stalloc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc

lib.o: lib.asm
	@mkdir -p build/
	fasm lib.asm build/lib.o
