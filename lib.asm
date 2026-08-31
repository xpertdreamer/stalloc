format ELF64

public stalloc

macro call_brk argument{
  mov rax, 12
  mov rdi, argument
  syscall
}

define PAGESIZE 0x1000

section '.data' writable
  first_alloc dq 0x00

section '.text' executable

stalloc:
  ; brk(0) call to find heap start
  push rdi
  call_brk 0
  pop rdi
  ; if brk(0) == 0 -> error
  test rax, rax
  jz .error
  ; mov brk(0) returned address to mem and call brk(heap_start+page_size)
  mov qword [first_alloc], rax
  lea rdi, [rax+PAGESIZE]
  call_brk rdi
  ; if brk(heap_start+page_size) == 0 -> error
  test rax, rax
  jz .error
  ; return heap_start
  mov rax, [first_alloc]
  ret
.error:
  xor rax, rax
  ret
