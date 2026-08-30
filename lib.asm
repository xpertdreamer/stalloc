format ELF64

public _start

extrn printf
extrn exit

section '.data' writable
  ; msg db "Hello, number %d!", 0xA, 0

section '.text' executable

_start:
  ; mov rdi, msg
  ; mov rsi, 9
  ; call printf
  ; xor rdi, rdi
  ; call exit
