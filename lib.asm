format ELF64

public _start

extrn printf
extrn exit

macro call_brk argument{
  mov rax, 12
  mov rdi, argument
  syscall
}

define PAGESIZE 0x1000
  
section '.data' writable
  heap_start dq 0x00
  msg_heap_start db "brk_start: 0x%x", 0xA, 0
  msg_heap_curr db "current brk: 0x%x", 0xA, 0

section '.text' executable

_start:
  call_brk 0

  mov rdi, msg_heap_start
  mov [heap_start], rax
  mov rsi, [heap_start]
  call printf

  mov rcx, [heap_start]
  add rcx, PAGESIZE
  call_brk rcx

  mov rdi, msg_heap_curr
  mov rsi, rax
  call printf

  xor rdi, rdi
  call exit
